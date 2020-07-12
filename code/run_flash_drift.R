library(tidyverse)
library(ebnm)
library(flashier)
library(drift.alpha)
options(extrapolate.control = list(beta.max=1.0))

args = commandArgs(trailingOnly=TRUE)
greedy_rds_path= args[1]
drift_rds_path = args[2]

greedy_flash_fit = readRDS(greedy_rds_path)
init <- init_from_flash(greedy_flash_fit)
dr <- drift(init, verbose=TRUE, extrapolate=FALSE, maxiter=20, tol=1e-5)
dr2 <- drift(dr, verbose=TRUE, extrapolate=TRUE, maxiter=2500, tol=1e-5)

# save the rds
saveRDS(dr2, drift_rds_path)
