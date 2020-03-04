### Script for parsing gtex data v7 ###
# Source: Peter Carbonetto, Stephens Lab, UChicago

### commands to set up environ on cluster ###
# sinteractive --partition=broadwl --exclusive --time=24:00:00
# module load R/3.5.1
# module load pandoc/1.13
# R --no-save

# Set paths: 
data.dir     <- file.path("..","data")
samples.file <- "GTEx_v7_Annotations_SampleAttributesDS.txt"
counts.file  <- "GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_reads.gct.gz"

# set out directory
out.dir         <- file.path("..","output")
counts.out.file <- "gtex.csv"
factors.file    <- "gtex_factors_rough.csv"
loadings.file   <- "gtex_loadings_rough.csv"

# Set "topics"
K <- 20

# set up environment 
library(readr)
library(rsvd)
library(ggplot2)
library(cowplot)
library(NNLM)
source(file.path("..","code","gtex.R"))

# loading and preparing data 
samples.file <- file.path(data.dir,samples.file)
counts.file  <- file.path(data.dir,counts.file)
out          <- read.gtex.data(samples.file,counts.file)

# collect info from 
samples      <- out$samples
counts       <- out$counts
rm(out)

# overview of gene expression
cat(sprintf("Number of genes: %d\n",ncol(counts)))
cat(sprintf("Number of samples: %d\n",nrow(counts)))
cat(sprintf("Proportion of counts that are non-zero: %0.1f%%.\n",
            100*mean(counts > 0)))
cat(sprintf("Number of tissue types (general, specific): %d, %d\n",
            nlevels(samples$general),nlevels(samples$specific)))
