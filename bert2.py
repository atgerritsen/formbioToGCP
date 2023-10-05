import os
import torch
import numpy as np
from transformers import AutoTokenizer, AutoModel

# Load the DNABERT model and tokenizer
tokenizer = AutoTokenizer.from_pretrained("zhihan1996/DNABERT-2-117M", trust_remote_code=True)
model = AutoModel.from_pretrained("zhihan1996/DNABERT-2-117M", trust_remote_code=True)

# Directory containing the genomes
genome_dir = "."

def process_genome(genome_path):
    # Assuming the genome is a simple string for this example
    with open(genome_path, 'r') as file:
        genome = file.read().replace('\n', '')

    # Split the genome into chunks (let's say of size 500)
    chunk_size = 500
    chunks = [genome[i:i + chunk_size] for i in range(0, len(genome), chunk_size)]

    all_mean_embeddings = []
    all_max_embeddings = []

    for chunk in chunks:
        # Calculate embeddings
        inputs = tokenizer(chunk, return_tensors = 'pt', truncation=True, 
max_length=512)["input_ids"]
        hidden_states = model(inputs)[0]  # [1, sequence_length, 768]

        # embedding with mean pooling
        embedding_mean = torch.mean(hidden_states[0], dim=0).detach().numpy()
        all_mean_embeddings.append(embedding_mean)

        # embedding with max pooling
        embedding_max = torch.max(hidden_states[0], dim=0)[0].detach().numpy()
        all_max_embeddings.append(embedding_max)

    # Convert embeddings lists to numpy arrays
    all_mean_embeddings = np.array(all_mean_embeddings)
    all_max_embeddings = np.array(all_max_embeddings)

    # Save embeddings as CSV
    genome_name = os.path.basename(genome_path).replace(".fasta", "")
    np.savetxt(f"{genome_name}_mean_embeddings.csv", all_mean_embeddings, delimiter=",")
    np.savetxt(f"{genome_name}_max_embeddings.csv", all_max_embeddings, delimiter=",")

# Loop through each genome file in the directory and process it
for genome_file in os.listdir(genome_dir):
    if genome_file.endswith('.fasta'):
        process_genome(os.path.join(genome_dir, genome_file))

