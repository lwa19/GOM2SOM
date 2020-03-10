######## Analysis of Read Counts for Peng data ############
library(data.table)
library(maptpx)
library(CountClust)

# setup environ
setwd('~/Documents/GitHub/GOM2SOM/')
indir <- 'data/'
outdir <- 'output/'

# Read in data and id:
data <- data.frame(fread(paste0(indir, 'peng.csv')))
samples_id=read.table(paste0(indir,'peng_data.txt'), header=T)

# Calculate clusters
Topic_Clus=topics(as.matrix(data),20,kill=0,tol=0.1)
docweights=Topic_Clus$omega
dim(docweights)
# [1] 41 20

