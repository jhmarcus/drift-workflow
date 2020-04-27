library(tidyverse)
library(ebnm)
library(flashier)
library(drift.alpha)

args = commandArgs(trailingOnly=TRUE)
greedy_rds_path= args[1]
drift_rds_path = args[2]

greedy_flash_fit = readRDS(greedy_rds_path)
# run drift
fl <- drift(init_from_flash(greedy_flash_fit), 
            miniter=500, 
            maxiter=2500, tol=0.001, verbose=TRUE)

# save the rds
saveRDS(fl, drift_rds_path)
