plot.peng.pcs <- function (tissues, pcs, x = "PC1", y = "PC2",
                           guide = "legend") {
  
  # Specify the colours and shapes used in the scatterplot.
  colors <- c("#E69F00","#56B4E9","#009E73","#0072B2")

  
  # Collect all the data used for the plot into a single data frame.
  pdat <- cbind(data.frame(tissue = tissues),pcs)
  
  # Create the scatterplot.
  return(ggplot(pdat,aes_string(x = x,y = y)) + #,color = "tissue", shape = "tissue")) +
           geom_point() +
           scale_x_continuous(breaks = NULL) +
           scale_y_continuous(breaks = NULL) +
           scale_color_manual(values = colors,guide = guide) +
           theme_cowplot(font_size = 12) +
           theme(legend.title = element_blank()))
}