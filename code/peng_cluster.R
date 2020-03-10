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
sample_labels <- read.table(paste0(indir,'peng_data.txt'), header=T,
                             stringsAsFactors = FALSE)

# Calculate clusters
Topic_Clus=topics(as.matrix(data),20,kill=0,tol=0.1)
docweights=Topic_Clus$omega
dim(docweights)
# [1] 41 20

# Structure Plot:
colnames(docweights) <- c(1:NCOL(docweights)) # formatting
tissue_labels <- vector("numeric", NROW(sample_labels))
tissue_labels <- sample_labels[,2]

# Clean labels (DOUBBLE CHECK NAMES FOR L AND R)
tissue_labels[grep("A", tissue_labels)] <- "Anterior"
tissue_labels[grep("P", tissue_labels)] <- "Posterior"
tissue_labels[grep("L", tissue_labels)] <- "Lateral - L"
tissue_labels[grep("R", tissue_labels)] <- "Lateral - R"

# find sample orders in hierarchical clustering
docweights_per_tissue_mean <- apply(docweights, 2,
                                    function(x) { tapply(x, tissue_labels, mean) })
ordering <- heatmap(docweights_per_tissue_mean)$rowInd
# Add the save to pdf function if we want to keep this. I saved it manually for now

# order tissue by hierarhical clustering results
tissue_levels_reordered <- unique(tissue_labels)[ordering]

annotation <- data.frame(
  sample_id = paste0("X", 1:length(tissue_labels)),
  tissue_label = factor(tissue_labels,
                        levels = rev(tissue_levels_reordered ) ) )


cols1 <- c(rev(RColorBrewer::brewer.pal(12, "Paired"))[c(3,4,7,8,11,12,5,6,9,10)],
           RColorBrewer::brewer.pal(12, "Set3"))
StructureGGplot(omega = docweights,
                annotation= annotation,
                palette = cols1,
                yaxis_label = "",
                order_sample = TRUE,
                split_line = list(split_lwd = .1,
                                  split_col = "white"),
                axis_tick = list(axis_ticks_length = .1,
                                 axis_ticks_lwd_y = .1,
                                 axis_ticks_lwd_x = .1,
                                 axis_label_size = 5,
                                 axis_label_face="bold"))
