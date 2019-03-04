

get_pops = function(meta_df, region){
    
  library(dplyr)
  
  pops = meta_df %>% filter(Region==region) %>% 
         dplyr::select(Region, Simple.Population.ID, Latitude) %>%
         distinct(Simple.Population.ID, Latitude) %>% 
         arrange(desc(Latitude)) %>% 
         pull(Simple.Population.ID)
    
    return(pops)
}


positive_structure_plot = function(gath_df, colset, facet_levels, facet_grp="Simple.Population.ID", label_size=5){
  
  library(ggplot2)
  library(tidyr)
  library(dplyr)
  library(RColorBrewer)
    
  p = ggplot(data=gath_df, aes(x=reorder(ID, desc(value)), y=value, fill=factor(K))) + 
      geom_bar(stat="identity", width=1) +  
      scale_fill_brewer(palette = colset) + 
      scale_y_continuous(expand=c(0, 0)) +
      scale_x_discrete(expand=c(-1, 0)) +
      facet_grid(. ~ factor(get(facet_grp), levels=facet_levels), scales = "free", space="free", switch="both") + 
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