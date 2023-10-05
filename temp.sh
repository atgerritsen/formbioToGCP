#!/bin/bash

# Check if the input file is specified
if [ -z "$1" ]; then
    echo "Usage: $0 <path/to/input_file.txt>"
    exit 1
fi

# Loop over each accession number in the input file and fetch gene ID
while IFS= read -r accession; do
    if [[ -z "$accession" || "$accession" == \#* ]]; then
        continue
    fi
    echo -n "Fetching gene ID for $accession..."
    gene_id=$(esearch -db nucleotide -query "$accession" | \
              elink -target gene | \
              efetch -format uid)
    echo "$accession    $gene_id"
    sleep 5
done < "$1"

