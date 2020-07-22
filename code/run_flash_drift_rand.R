library(tidyverse)
library(ebnm)
library(flashier)
library(drift.alpha)
library(softImpute)
library(lfa)
options(extrapolate.control=list(beta.max=1.0))

args <- commandArgs(trailingOnly=TRUE)
bed_prefix <- args[1]
rds_path <- args[2]
K <- as.integer(args[3])
KCOMPLETE <- 30

# read the genotype matrix
Y <- t(lfa:::read.bed(bed_prefix))

# complete missing data before running
fit <- softImpute(Y, rank=KCOMPLETE, lambda=0.0, type="als")
Y_imp <- complete(Y, fit)

# random init
n <- nrow(Y_imp)
EL <- matrix(runif(n * K), nrow=n, ncol=K)
EL[, 1] <- 1
EF <- t(solve(crossprod(EL), crossprod(EL, Y))) 
dr <- drift(init_from_EL(Y, EL, EF), miniter=20, maxiter=20, extrapolate=FALSE, verbose=TRUE)
dr <- drift(dr, miniter=2, maxiter=2500, tol=1e-4, extrapolate=TRUE, verbose=TRUE)

# save the rd 
saveRDS(dr, rds_path)
