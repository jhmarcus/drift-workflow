#' @title Simpler Tree Simulation
#'
#' @description Simulates genotypes under a simple population 
#'              tree as described in Pickrell and Pritchard 2012 via 
#'              a factor analysis model:
#'
#'              https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1002967
#'
#' @param n_per_pop number of individuals per population
#' @param p number of SNPs
#' @param sigma_e std. dev of noise
simpler_tree_simulation = function(n_per_pop, p, sigma_e){
  
  n = n_per_pop * 4
  L = matrix(0, nrow=4*n_per_pop, ncol=6)
  L[1:n_per_pop, 2] = L[1:n_per_pop, 6] = 1
  L[(n_per_pop + 1):(2*n_per_pop), 2] = L[(n_per_pop + 1):(2*n_per_pop), 5] = 1
  L[(2*n_per_pop + 1):(3*n_per_pop), 1] = L[(2*n_per_pop + 1):(3*n_per_pop), 3] = 1
  L[(3*n_per_pop + 1):(4*n_per_pop), 1] = L[(3*n_per_pop + 1):(4*n_per_pop), 4] = 1
  
  Z = matrix(rnorm(p*6, 0, 1), nrow=p, ncol=6)
  E = matrix(rnorm(n*p, 0, sigma_e), nrow=n, ncol=p)
  Y = L %*% t(Z) + E
  
  res = list(Y=Y, L=L, Z=Z)
  
  return(res)
  
}


#' @title Simplest Tree Simulation
#'
#' @description Simulates genotypes under a very simple two population 
#'              tree.
#'
#' @param n_per_pop number of individuals per population
#' @param p number of SNPs
#' @param sigma_e std. dev of noise
simplest_tree_simulation = function(n_per_pop, p, sigma_e){
  
  n = n_per_pop * 2
  L = matrix(0, nrow=2*n_per_pop, ncol=2)
  L[1:n_per_pop, 1] = 1
  L[(n_per_pop + 1):(2*n_per_pop), 2] = 1
  
  Z = matrix(rnorm(p*2, 0, 1), nrow=p, ncol=2)
  E = matrix(rnorm(n*p, 0, sigma_e), nrow=n, ncol=p)
  Y = L %*% t(Z) + E
  
  res = list(Y=Y, L=L, Z=Z)
  
  return(res)
  
}