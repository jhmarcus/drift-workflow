library(tidyverse)
library(ebnm)
library(flashier)
library(drift.alpha)
library(softImpute)
library(lfa)

args <- commandArgs(trailingOnly=TRUE)
bed_prefix <- args[1]
rds_path <- args[2]
KMAX <- as.integer(args[3])
KCOMPLETE <- 30

# read the genotype matrix
Y <- t(lfa:::read.bed(bed_prefix))

# complete missing data before running
fit <- softImpute(Y, rank=KCOMPLETE, lambda=0.0, type="als")
Y_imp <- complete(Y, fit)

# run flash
fl <- flash(Y_imp, greedy.Kmax=KMAX, prior.family=c(prior.bimodal(), prior.normal()))

# save the rds
saveRDS(fl, rds_path)
