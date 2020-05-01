library(tidyverse)
library(ebnm)
library(flashier)
library(drift.alpha)
library(lfa)

args = commandArgs(trailingOnly=TRUE)
bed_prefix = args[1]
rds_path = args[2]
KMAX = as.integer(args[3])

# read the genotype matrix
Y <- t(lfa:::read.bed(bed_prefix))

# run flash
fl <- flash(Y, greedy.Kmax=KMAX, prior.family=c(prior.bimodal(), prior.normal()))

# save the rds
saveRDS(fl, rds_path)
