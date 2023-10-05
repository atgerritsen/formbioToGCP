from Bio import Entrez
from time import sleep

# Set your email (important for NCBI records)
Entrez.email = "alida@colossal.com"

def get_nucleotide_accession(protein_id):
    try:
        handle = Entrez.elink(dbfrom="protein", db="nuccore", id=protein_id)
        record = Entrez.read(handle)
        handle.close()

        # Check if 'LinkSetDb' exists in the record and is not empty
        if 'LinkSetDb' in record[0] and record[0]['LinkSetDb']:
            nucleotide_id = record[0]['LinkSetDb'][0]['Link'][0]['Id']

            handle = Entrez.efetch(db="nuccore", id=nucleotide_id, rettype="gb", retmode="text")
            record_text = handle.read()
            handle.close()
            
            for line in record_text.split("\n"):
                if line.startswith("VERSION"):
                    return line.split()[1]
        else:
            print(f"No direct link found for {protein_id}")
            return None

    except Exception as e:
        print(f"Error for {protein_id}: {str(e)}")
        return None

if __name__ == '__main__':
    # Load protein IDs from a txt file
    with open('protein_accessions.txt', 'r') as file:
        protein_ids = [line.strip() for line in file]

    with open('results.txt', 'w') as f:
        for protein_id in protein_ids:
            nucleotide_id = get_nucleotide_accession(protein_id)
            if nucleotide_id:
                f.write(f"{protein_id}\t{nucleotide_id}\n")
            else:
                f.write(f"{protein_id}\tNo corresponding nucleotide record found\n")
            sleep(1)  # Pauses the script for 1 second

