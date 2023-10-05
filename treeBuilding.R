# following https://cran.r-project.org/web/packages/phangorn/vignettes/Trees.html
# best to skip this part and use the estimateTreeAll fn because you don't need to independently determine tree topology

library(phangorn)

#cux1 <- read.phyDat(file.path("cux1.alignment.fasta"), format = "fasta")
#cux1.mt <-modelTest(cux1)
#fit.cux1.mt <- pml_bb(cux1.mt, control=pml.control(trace=0))
#remove those node labels, bootstrap vals should be removed for RER
#cux1tree <- fit.cux1.mt$tree
#cux1tree$node.label <- NULL
#write.tree(cux1tree, "cux1.tree")

# RER walkthrough: https://clark.genetics.utah.edu/wp-content/uploads/2020/11/FullWalkthroughUTD.html

library(RERconverge)
setwd("~/Documents/Dodo/dodo_bioinfo/RERconverge_proj/alignmentsAndTrees")

masterSppTree <- ape::read.tree("masterSppTree.tre")
masterSppTree$node.label <- NULL

estimatePhangornTreeAll(
  alndir = "./alignments/",
  pattern = ".fasta",
  treefile = "masterSppTree.tre",
  output.file = "genesForRER.tree")

geneTrees <- readTrees("genesforRER.tree")

# binary phenotype vector

# flightPheno <- read.csv("binaryPheno - Sheet1.csv")
# match body mass to tip labels from master.tree
# flightVals <- flightPheno$flight[match(masterSppTree$tip.label, flightPheno$species)]

flightRER <- getAllResiduals(geneTrees)

# set outgroup for plots

# plotCasColStr <- plotTreeHighlightBranches(tree = geneTrees$masterTree, hlspecies = c("ColLiv", "CasCas", "StrHab"))
# fgf10Plot <- plotTreeHighlightBranches(geneTrees$trees$fgf10.al, hlspecies = c("ColLiv", "CasCas", "StrHab"), main = "FGF10")

fgfr1Plot <- plotTreeHighlightBranches(geneTrees$trees$fgfr1.al, hlspecies = c("ColLiv", "CasCas", "StrHab"), main = "FGFR1")
fgfr2Plot <- plotTreeHighlightBranches(geneTrees$trees$fgfr2.al, hlspecies = c("ColLiv", "CasCas", "StrHab"), main = "FGFR2")
tbx4Plot <- plotTreeHighlightBranches(geneTrees$trees$tbx4.al, hlspecies = c("ColLiv", "CasCas", "StrHab"), main = "TBX4")
tbx5 <- plotTreeHighlightBranches(geneTrees$trees$tbx5.al, hlspecies = c("ColLiv", "CasCas", "StrHab"), main = "TBX5")

# plot the RERs for specific genes along the vector
tbx4RERs <- returnRersAsTree(geneTrees, rermat = flightRER, "tbx4.al", plot=T)

# Binary trait analysis - the tree itself is already the phenotype vector

flightBinary <- read.tree("masterBinary.tre")
testyPheno <- tree2Paths(flightBinary, geneTrees)
# had to use the tree2paths function, otherwise it becomes a list problem

corFlight <- correlateWithBinaryPhenotype(flightRER, testyPheno)

# take a look at the numbers results

head(corFlight[order(corFlight$P),])
# Rho  N         P     p.adj
# fgf10.al -0.217869577 22 0.2317308 0.9553504
# tbx5.al  -0.100722031 28 0.5287976 0.9553504
# fgfr1.al  0.085592099 27 0.5996592 0.9553504
# tbx4.al  -0.034421012 33 0.8152996 0.9553504
# fgfr2.al  0.008953588 28 0.9553504 0.9553504

# print some correlation results
fgf10Cor <- plotRers(flightRER, "fgf10.al", phenv = testyPheno)
tbx4Cor <- plotRers(flightRER, "tbx4.al", phenv = testyPheno)

tbx4Cor + 
  theme(axis.ticks.y=element_blank(),axis.text.y=element_blank(),legend.position="none",
        panel.background = element_blank(),
        axis.text=element_text(size=8,face='bold',colour = 'black'),
        axis.title=element_text(size=12,face="bold"),
        plot.title= element_text(size = 12, face = "bold"))+
  theme(axis.line = element_line(colour = 'black',linewidth = 1))+
  theme(axis.line.y = element_blank())
ggsave("~/Desktop/test.png", width=12, height=8, scale=.5)


# continuous trait analysis with Hand Wing Index (HWI)

hwiFile<- read.csv("conPhenoHWI.csv")
hwiVals <- hwiFile$hwi
hwiNames <- hwiFile$species

# create the vector named numbers
names(hwiVals) <- hwiNames
# hwiVals <- hwiFile$hwi[match(masterSppTree$tip.label, hwiFile$species)]
# masterSppTree$edge.length <- hwiVals

# 
charpaths <- char2Paths(hwiVals, workTrees)

res <- correlateWithContinuousPhenotype(workRER, charpaths, min.sp = 10,
                                     winsorizeRER = 3, winsorizetrait = 3)
head(res[order(res$P),])


# lifted this directly from the vignette to plot gene correlations:
x=charpaths
y=workRER['tbx5.al',]
pathnames=namePathsWSpecies(workTrees$masterTree)
names(y)=pathnames
plot(x,y, cex.axis=1, cex.lab=1, cex.main=1, xlab="Hand Wing Index",
     ylab="Evolutionary Rate", main="Gene TBX5 Pearson Correlation",
     pch=19, cex=1, xlim=c(-2,2))
text(x,y, labels=names(y), pos=4)
abline(lm(y~x), col='red',lwd=3)
