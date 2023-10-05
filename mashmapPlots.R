library(pafr)
library(ggplot2)

cat2leop <- read_paf("genome_data/mashmapCat2leopard.out")
# c2l.plot <- dotplot(cat2leop, order_by = "qstart", label_seqs = T, alignment_colour = "red")

# Generate the dot plot
# ggplot(cat2leop, aes(x = qlen, xend = qend, y = tlen, yend = tend)) +
#   geom_segment(color="blue") +
#   labs(x = "Falis catus", y = "Neofelis nebulosa", title = "Genome to Genome comparison") +
#   theme_minimal()


# this one only uses the start points of the alignments and uses transparency for maximum viewability
ggplot(cat2leop, aes(x = qstart, y = tstart)) +
  geom_point(color="dark green", alpha=0.3) +
  labs(x = "Cat", y = "Leopard", title = "Genome to Genome") +
  theme_minimal()
