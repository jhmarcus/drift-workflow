

get_pops = function(meta_df, region){
    
  pops = meta_df %>% filter(region==region) %>% 
         select(region, clst, lat) %>%
         distinct(clst, lat) %>% 
         arrange(desc(lat)) %>% 
         pull(clst)
    
    return(pops)
}


positive_structure_plot = function(gath_df, pops, K_, label_size=5){
  
  library(ggplot2)
  library(tidyr)
  library(dplyr)
  library(RColorBrewer)
    
  getPalette = colorRampPalette(brewer.pal(12, "Set3"))
  p = ggplot(data=gath_df, aes(x=reorder(iid, desc(value)), y=value, fill=factor(K, levels=2:K_))) + 
      geom_bar(stat="identity", width=1) +  
      scale_fill_manual(values = getPalette(K_)) + 
      scale_y_continuous(expand=c(0, 0)) +
      scale_x_discrete(expand=c(-1, 0)) +
      facet_grid(. ~ factor(clst, levels=pops), scales = "free", space="free", switch="both") + 
      theme_classic() +
      theme(panel.spacing = unit(0.2, "lines"), 
            strip.background = element_rect(colour="white", fill="white"),
            strip.text.x = element_text(size = label_size, colour = "black", angle = 90, hjust = 1.1), 
            strip.placement = "outside", 
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            axis.text.x=element_blank(), 
            axis.ticks.x=element_blank()) + 
      ylab("") + 
      xlab("") + 
      guides(fill=F)
  
  return(p)
  
}