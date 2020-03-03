#install.packages('here')
data.dir <- here::here("data")
counts.file <- "GSE65924_E1.gene.expression.txt"

out.dir <- here::here("output")
counts.out.file <- "gtex.csv"
factors.file <- "gtex_factors_rough.csv"
loadings.file <- "gtex_loadings_rough.csv"
K <- 20

#install.packages('readr')
#install.packages('rsvd')
#install.packages('ggplot2')
#install.packages('cowplot')
#install.packages('NNLM')
#install.packages('readtext')

library(readr)
library(rsvd)
library(ggplot2)
library(cowplot)
library(readtext)
#library(NNLM)


counts.file  <- file.path(data.dir,counts.file)
out          <- readtext(counts.file)
counts       <- out$counts
rm(out)

cat(sprintf("Number of genes: %d\n",nrow(counts)))
cat(sprintf("Number of samples: %d\n",ncol(counts)))
cat(sprintf("Proportion of counts that are non-zero: %0.1f%%.\n",
            100*mean(counts > 0)))
#cat(sprintf("Number of tissue types (general, specific): %d, %d\n",
 #           nlevels(samples$general),nlevels(samples$specific)))
