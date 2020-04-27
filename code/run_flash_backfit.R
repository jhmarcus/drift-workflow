library(tidyverse)
library(ebnm)
library(flashier)
library(drift.alpha)

args = commandArgs(trailingOnly=TRUE)
greedy_rds_path= args[1]
backfit_rds_path = args[2]

greedy_flash_fit = readRDS(greedy_rds_path)
fl <- greedy_flash_fit %>% 
      flash.backfit() %>% 
      flash.nullcheck(remove=TRUE)

# save the rds
saveRDS(fl, backfit_rds_path)
