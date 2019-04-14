prepare_snp_data = function(flash_fit, bim_path){
  
  K = flash_fit$n.factors
  
  bim_df = read.table(bim_path, header=F)
  colnames(bim_df) = c("chrom", "rsid", "cm", "pos", "a1", "a2")
  
  df = as.data.frame(flash_fit$loadings$normalized.loadings[[2]])
  colnames(df) = 1:K
  df$chrom = bim_df$chrom
  df$pos = bim_df$pos
  df$rsid = bim_df$rsid
  
  # add mean and precision estimates
  df$mu = sqrt(flash_fit$loadings$scale.constant[1]) * delta_df$`1`
  df$tau = flash_fit$fit$est.tau

  return(df)
  
}