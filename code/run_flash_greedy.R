library(tidyverse)
library(ebnm)
library(flashier)
library(drift.alpha)
library(softImpute)
library(lfa)

# args
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

# run greedy flash with a fixed first factor
ones <- matrix(1, nrow=nrow(Y_imp), ncol=1)
ls.soln <- t(solve(crossprod(ones), crossprod(ones, Y_imp)))
fl <- flash.init(Y_imp) %>%
      flash.init.factors(EF=list(ones, ls.soln), 
                         prior.family=c(prior.bimodal(), 
                                        prior.normal())) %>%
      flash.fix.loadings(kset=1, mode=1L) %>%
      flash.backfit() %>%
      flash.add.greedy(Kmax=KMAX, prior.family=c(prior.bimodal(), prior.normal()))

# save the rds
saveRDS(fl, rds_path)
