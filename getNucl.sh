#!/bin/bash

# Filename with the list of accession numbers
FILENAME="XM_accessions.txt"

# Loop through each accession number
while read -r ACCESSION; do
    efetch -db nuccore -id "$ACCESSION" -format fasta
    sleep 1 # pauses for 1 second
done < "$FILENAME"

