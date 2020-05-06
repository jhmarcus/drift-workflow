get_pops = function(meta_df, region){
    
  library(dplyr)
  
  pops = meta_df %>% filter(Region==region) %>% 
         dplyr::select(Region, Simple.Population.ID, Latitude) %>%
         distinct(Simple.Population.ID, Latitude) %>% 
         arrange(desc(Latitude)) %>% 
         pull(Simple.Population.ID)
    
    return(pops)
  
}


structure_plot = function(gath_df, colset, facet_levels, facet_grp="Simple.Population.ID", label_size=5, keep_leg=F, fact_type){
  
  library(ggplot2)
  library(tidyr)
  library(dplyr)
  library(RColorBrewer)
    
  if(fact_type=="structure"){
    p_init = ggplot(data=gath_df, aes(x=reorder(ID, value, function(x){max(x)}), y=value, 
                                      fill=reorder(K, sort(as.integer(K)))))
  } else if(fact_type=="nonnegative"){
    p_init = ggplot(data=gath_df, aes(x=reorder(ID, value), y=value, 
                                      fill=reorder(K, sort(as.integer(K)))))
  }
  
  p = p_init + 
      geom_bar(stat="identity", width=1) +  
      scale_fill_brewer(palette = colset) + 
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
      theme(legend.position="bottom") +
      ylab("") + 
      xlab("") + 
      labs(fill="K") 

  if(keep_leg==FALSE){
    p = p + guides(fill=F) 

  }
  
  return(p)
  
}


plot_pve = function(flash_fit){
  
  p = qplot(1:flash_fit$n.factors, flash_fit$pve) + 
      ylab("Proportion of Varaince Explained") + 
      xlab("K") + 
      theme_bw()
  
  return(p)
  
}


plot_factors = function(snp_df, rel_size=.5){
  
  gath_snp_df = snp_df %>% 
                gather(variable, value, -chrom, -pos, -rsid, -mu, -tau) %>%
                filter(variable!="1")
  
  p = ggplot(gath_snp_df, aes(x=value)) +
      geom_histogram() +
      facet_wrap(factor(variable, levels=paste0(2:K))~., scales="free") +
      scale_x_continuous(breaks = scales::pretty_breaks(n = 3)) +
      scale_y_continuous(breaks = scales::pretty_breaks(n = 3)) + 
      theme_bw() + 
      xlab("Factor") + 
      ylab("Count") + 
      theme(axis.text.x=element_text(size=rel(rel_size)), 
            axis.text.y=element_text(size=rel(rel_size))
      )
  
  return(p)
  
}


plot_variance = function(snp_df){
  
  p = qplot(1/snp_df$tau) + 
      xlab("Estimated Variance") + 
      ylab("Count") + 
      theme_bw()
  
  return(p)
  
}


plot_mean = function(snp_df){
  
  p = qplot(snp_df$mu) + 
      xlab("Estimated Mean") + 
      ylab("Count") + 
      theme_bw()
  
  return(p)
  
}


plot_mean_variance = function(snp_df){
  
  p = ggplot(snp_df, aes(x=mu, y=1/tau)) + 
      geom_point() + 
      xlab("Estimated Mean") + 
      ylab("Estimated Variance") + 
      scale_alpha(guide = "none") + 
      stat_function(fun = function(x){return(2*x*(1-x))}, color="red") + 
      xlim(0, .5) + 
      theme_bw() 
  
  return(p)
  
}


plot_covmat = function(S){
  
  s_df = reshape2::melt(S)
  p = ggplot(s_df, aes(x=Var1, y=Var2, fill=value)) + 
      geom_tile() +
      viridis::scale_fill_viridis(option="D") +
      theme_minimal() +
      labs(fill="Covariance") +
      xlab("") +
      ylab("")
  
  return(p)
  
}