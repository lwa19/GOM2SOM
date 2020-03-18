### Script for parsing som data (Peng xxxx) ###
# Source: Peter Carbonetto, Stephens Lab, UChicago

### commands to set up environ on cluster ###
# sinteractive --partition=broadwl --exclusive --time=24:00:00
# module load R/3.5.1
# module load pandoc/1.13
# R --no-save

# Set paths: 
setwd('~/Documents/GitHub/GOM2SOM/')
data.dir     <- file.path("data")
samples.file <- "peng_data.txt"
counts.file  <- "GSE65924_E1.gene.expression.txt.gz"

# set out directory
out.dir       <- file.path("output")
counts.out.file <- "peng.csv"
factors.file    <- "peng_factors_rough.csv"
loadings.file   <- "peng_loadings_rough.csv"

# Set "topics"
K <- 20

# set up environment 
library(readr)
library(rsvd)
library(ggplot2)
library(cowplot)
library(NNLM)
source(file.path("code","peng.R"))

# loading and preparing data 
samples.file <- file.path(data.dir,samples.file)
counts.file  <- file.path(data.dir,counts.file)
samples      <- read.table(samples.file, header = TRUE, sep = '\t')
counts       <- read.table(gzfile(counts.file), header = TRUE, sep = '\t')

genes.in.order = colnames(counts)
save(genes.in.order, file = 'data/gene_names.rdata')

# transform the samples data.frame
rownames(samples) <- samples$sample
samples <- samples[-1]

# transform the counts data.frame into the same as counts
rownames(counts) <- counts$Genes
counts <- t(counts[-1])
counts <- as.matrix(counts)

# overview of gene expression
cat(sprintf("Number of genes: %d\n",ncol(counts)))
cat(sprintf("Number of samples: %d\n",nrow(counts)))
cat(sprintf("Proportion of counts that are non-zero: %0.1f%%.\n",
            100*mean(counts > 0)))

# calculate principle components
set.seed(1)
timing <- system.time(
  out <- rpca(counts,k = 20,center = TRUE,scale = FALSE,retx = TRUE))
cat(sprintf("Computation took %0.2f seconds.\n",timing["elapsed"]))
pcs        <- as.data.frame(out$x)
names(pcs) <- paste0("PC",1:20)
rm(out)

# plot 
tissues <- samples$domain

pdf.dir <- file.path(out.dir, 'peng_pca.pdf')
pdf(pdf.dir)
plot.peng.pcs(tissues,pcs)
dev.off()

pdf("peng_pca_grid.pdf")
plot_grid(plot.peng.pcs(tissues,pcs,"PC3","PC4",guide = "none"),
          plot.peng.pcs(tissues,pcs,"PC5","PC6",guide = "none"),
          plot.peng.pcs(tissues,pcs,"PC7","PC8",guide = "none"),
          plot.peng.pcs(tissues,pcs,"PC9","PC10",guide = "none"),
          nrow = 2,ncol = 2)
dev.off()

# calculation
timing <- system.time(
  fit <- nnmf(counts,K,method = "scd",loss = "mkl",rel.tol = 1e-8,
              n.threads = 0,max.iter = 10,inner.max.iter = 4,trace = 1,
              verbose = 2))
cat(sprintf("Computation took %0.2f seconds.\n",timing["elapsed"]))

# write results to file
counts.out.file <- file.path(out.dir,counts.out.file)
counts          <- as.data.frame(counts)
write_csv(counts,counts.out.file,col_names = FALSE)

factors.file  <- file.path(out.dir,factors.file)
loadings.file <- file.path(out.dir,loadings.file)
F <- as.data.frame(round(t(fit$H),digits = 4))
L <- as.data.frame(round(fit$W,digits = 4))
write_csv(F,factors.file,col_names = FALSE)
write_csv(L,loadings.file,col_names = FALSE)