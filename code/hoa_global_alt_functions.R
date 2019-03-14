# These are some functions used bin the hoa_global_alt workflowr analysis.

# Load the results from the "loadings for peter" .rds file supplied by
# Joe, and return the data frame containing the factor loadings and
# other information about the samples.
load.results <- function (filename = "loadings-forpeter-03-12-2019.rds") {
  out <- readRDS(filename)$df
  rownames(out) <- out$ID
  names(out)[1:21] <- paste0("factor",1:21)
  return(out[c(23:26,1:21)])
}

# TO DO: Explain here what this function does.
plot.response.by.label <- function (x, label, group, threshold = 0.01) {

  # Colours used to represent the groups.
  colors <- c("#E69F00","#56B4E9","#009E73","#F0E442",
              "#0072B2","#D55E00","#CC79A7")
    
  # Remove all label in which the maximum response for that label is
  # less than (or equal to) the threshold.
  y     <- tapply(x,label,max)
  i     <- is.element(label,names(which(y >= threshold)))
  x     <- x[i]
  label <- factor(label[i])
  group <- group[i]

  # Sort the labels by median loading.
  y <- tapply(x,label,median)
  y <- sort(y)

  # Combine all the plotting data into a data frame.
  pdat <- data.frame(x     = x,
                     label = factor(label,names(y)),
                     group = group)

  # Create the plot.
  return(ggplot(pdat,aes_string(x = "x",y = "label",color = "group")) +
         stat_summaryh(fun.x = median,fun.xmin = function (x) quantile(x,0.05),
                       fun.xmax = function (x) quantile(x,0.95),
                       geom = "pointrangeh",size = 0.25) +
         scale_color_manual(values = colors,na.value = "gray",drop = FALSE) +
         theme_cowplot(font_size = 11) +
         theme(axis.ticks  = element_blank(),
               axis.line   = element_blank(),
               axis.text.y = element_text(size = 8)))
}

