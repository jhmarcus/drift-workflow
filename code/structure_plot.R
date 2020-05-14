create_structure_plot <- function(L, labels, colors, 
                                  label_order=NULL, 
                                  gap=1, 
                                  ymax=NULL,
                                  label_font_size=8,
                                  yaxis_tick_font_size=12,
                                  yaxis_title_font_size=12
                                  ){
  # TODO: assert label_order is unique 
  # TODO: assert label_order is in labels
  K <- ncol(L)
  if(is.null(label_order)){
    unique_labels <- unique(labels)
  } else {
    unique_labels <- label_order
  }
  nlabels <- length(unique_labels)
  ticks <- rep(0, nlabels)
  pdat <- NULL
  nt <- 0
  i <- 1
  for(label in unique_labels) {
    Li <- L[labels==label,]
    if(nrow(Li)!=1){
      di <- dist(Li)
      mds <- cmdscale(di, eig=FALSE, k=1)
      rows <- order(mds)
      Li <- Li[rows,]
    } 
    colnames(Li) <- 1:K
    ni <- nrow(Li)
    out <- as.data.frame(Li) %>% 
           mutate(sample=1:ni) %>% 
           gather(K, loading, -sample)
    out$sample <- out$sample + nt
    pdat <- rbind(pdat, out)
    ticks[i] <- nt + ni/2
    nt <- nt + ni + gap
    i <- i + 1
  }

  # Create the STRUCTURE plot.
  n <- max(pdat$sample)
  p <- ggplot(pdat,aes_string(x = "sample",y = "loading",
                                fill = "K")) +
           geom_bar(stat="identity", width=1) +  
           scale_x_continuous(limits = c(0.0,n+1),breaks = ticks,
                              labels = unique_labels, 
                              expand = c(0, 0)) +
           scale_y_continuous(expand=c(0, 0)) +
           scale_fill_manual(values=colors) + 
           theme_classic() +
           theme(panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(),
                 axis.text.y = element_text(size = yaxis_tick_font_size),
                 axis.text.x=element_text(size = label_font_size, colour = "black", angle = 45, hjust = 1), 
                 axis.ticks.x=element_blank(),
                 axis.line.x = element_blank(),
                 plot.margin = unit(c(0, 0, 0, 0), "cm"),
                 axis.title.y=element_text(size=yaxis_title_font_size)) + 
           ylab("Loading") + 
           guides(fill=FALSE, color=FALSE) +
           labs(x = "") 
  if(!is.null(ymax)){
    p <- p +
      expand_limits(y=c(0, ymax)) + 
      scale_y_continuous(limits=c(0, ymax), expand=c(0, 0)) 
  }
  return(p)
}

