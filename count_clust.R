# Replicate the GOM clustering in Dey 2017
# setting work directory:
setwd('~/Documents/GitHub/GOM2SOM/')

# Installing CountClust and maptpx
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("CountClust")
#install_github('TaddyLab/maptpx')
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("phantasus")

library('CountClust')
library('devtools')
library('phantasus')
library('maptpx')


# loading fitted data from Stephens Lab
load('data/GTExV6Brain.FitGoM.rda') # name: GTExV6Brain.FitGoM
brain_fit <- GTExV6Brain.FitGoM

# loading GTEx v6 data into R
data <- read.gct('data/v6_gene.gct')
#data <- read.table('data/v6_gene.gct', sep = '\t')
#data <- data.frame(fread('data/GTEx_Analysis_v6_RNA-seq_RNA-SeQCv1.1.8_gene_reads.gct.gz')
