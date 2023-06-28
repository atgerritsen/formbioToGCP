#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: ./scriptname.sh gene_list gtf_file genome_fasta output_file"
    exit 1
fi

# input file containing the gene names
input="$1"

# GTF file to search
gtf_file="$2"

# Genome fasta file
genome_fasta="$3"

# output file to store the results
output="$4"

# temporary bed file
bed_file="temp.bed"

# empty the bed and output files
> "$bed_file"
> "$output"

# iterate over each gene in the gene list
while IFS= read -r gene
do
  # print the gene name
  echo "Searching for transcript: $gene"

  # search for the gene in the GTF file and append the result to a bed file
  pcregrep -i "transcript.*gene \"$gene\"" "$gtf_file" | awk '{print $1 "\t" $4-1 "\t" $5}' >> "$bed_file"
done < "$input"

# Sort and remove duplicates from the BED file
sort -u -k1,1 -k2,2n -k3,3n "$bed_file" > "${bed_file}_unique"
mv "${bed_file}_unique" "$bed_file"

# Use bedtools getfasta to extract sequences from the genome fasta
bedtools getfasta -fi "$genome_fasta" -bed "$bed_file" -fo "$output"

# Remove the temporary bed file
rm "$bed_file"
