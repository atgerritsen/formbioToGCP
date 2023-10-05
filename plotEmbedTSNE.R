install.packages("Rtsne")
library(Rtsne)

# Load embeddings
embedding_mean <- read.csv("embedding_mean.csv", header = FALSE)
embedding_max <- read.csv("embedding_max.csv", header = FALSE)

# t-SNE for mean embedding
tsne_mean <- Rtsne(embedding_mean)

# t-SNE for max embedding
tsne_max <- Rtsne(embedding_max)

# Visualization
par(mfrow=c(1,2))

plot(tsne_mean$Y, main = "t-SNE of Mean Embedding", xlab="", ylab="", pch=20, col="blue")
plot(tsne_max$Y, main = "t-SNE of Max Embedding", xlab="", ylab="", pch=20, col="red")

