#!/bin/bash

# This is the file with your gene sequences
gene_list="genes.fasta"

# This is your custom blast database
blast_db="my_blast_db"

# Output file for the blast results
output_file="blast_results.txt"

# Temporary output file for sorted blast results
sorted_output_file="sorted_blast_results.txt"

# Running blastn
blastn -query $gene_list -db $blast_db -out $output_file -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore" -num_alignments 1

# Sorting the output by score (field 12 in reverse order) and then by query ID (field 1)
sort -k1,1 -k12,12nr $output_file > $sorted_output_file

# Selecting the top hit for each query sequence
awk '!visited[$1]++' $sorted_output_file > $output_file

# Get a list of unique species from the results
species=$(cut -f 2 $output_file | cut -d ' ' -f 2 | sort | uniq)

# For each species, extract relevant lines and write them to a separate file
for sp in $species; do
    awk -v species="$sp" '$2 ~ species {print $0}' $output_file > "${sp}_blast_results.txt"
done

# Remove the temporary file
rm $sorted_output_file
