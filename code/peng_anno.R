### Assign gene annotation to clusters ### 
# Reference: http://stephenslab.github.io/count-clustering/project/src/gene_annotation_2.html

# utilized libraries:
library(CountClust)
library(mygene)

# setup environ
setwd('~/Documents/GitHub/GOM2SOM/')
indir <- 'data/'
outdir <- 'output/'
codir <- 'code/'

# load in data:
# source(paste0(codir, 'peng_cluster.R'))
# wow that's a bad idea. It recalculates the topics models and takes hella long
GoM_output <- get(load(paste0(indir, 'peng.k.20.master.rda')))


# Extracting top driving genes
topics_theta <- GoM_output$theta
top_features <- ExtractTopFeatures(topics_theta, 
                                   top_features=100, 
                                   method="poisson", options="min")
top_genes <- top_features[[1]]


# read MGI marker
# obtained here: http://www.informatics.jax.org/downloads/reports/index.html#marker
MGI.table = read.delim(paste0(indir, 'peng_gene_list.txt'), 
                       header = T, sep = '\t') # data.frame

# match the name of genes with the MGI name
genes = as.vector(get(load(paste0(indir, 'gene_names.rdata'))))
genes.anno = MGI.table[match(genes, MGI.table$Marker.Symbol),]
gene_names = as.vector(genes.anno$Marker.Symbol)

gene_list <- do.call(rbind, lapply(1:dim(top_genes)[1], 
                                   function(x) gene_names[top_genes[x,]]))
write.table(gene_list, paste0(outdir, "/gene_names_all_gtex.txt"), col.names = FALSE,
            row.names=FALSE, quote=FALSE, sep = '\t')

# Well, mygene does not actually work, so I'm going to leave it with just names