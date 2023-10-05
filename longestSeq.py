def parse_gtf_line(line):
    """Parses a single line of a GTF file."""
    columns = line.strip().split('\t')
    if len(columns) < 9:
        return None, None, None, None
    attributes = columns[8]
    gene_name = None
    for field in attributes.split(';'):
        if "gene_name" in field:
            gene_name = field.split('"')[1]
            break
    start, end = int(columns[3]), int(columns[4])
    return gene_name, start, end, line

def get_longest_cds_for_each_gene(filename):
    """Parses the GTF and returns the longest CDS sequence for each gene."""
    gene_dict = {}
    with open(filename, 'r') as f:
        for line in f:
            gene_name, start, end, full_line = parse_gtf_line(line)
            if gene_name:
                length = end - start
                if gene_name not in gene_dict or length > gene_dict[gene_name][0]:
                    gene_dict[gene_name] = (length, full_line)

    return [val[1] for val in gene_dict.values()]

if __name__ == "__main__":
    gtf_file = "ColLiv.gtf"
    output_file = "longestColLiv.gtf"
    longest_cds_lines = get_longest_cds_for_each_gene(gtf_file)
    
    with open(output_file, 'w') as f:
        for line in longest_cds_lines:
            f.write(line)

    print(f"Results written to {output_file}")

