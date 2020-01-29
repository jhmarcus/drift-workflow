# Restart R first!

devtools::install_github("stephenslab/mixsqp", ref = "9cb5fca4dbcb4035df2c9c5fa0b716d7ed3e38c9")
library(flashier)

bimodal.fn = function(x, s, g_init, fix_g, output, grid_size) {

  if (is.null(g_init)) {
    m = as.integer(grid_size / 2)
    a <- c(rep(0, m), seq(0.5, 1, length = m))
    b <- c(seq(0, 0.5, length = m), rep(1, m))
    g_init <- ashr::unimix(rep(1/(2 * m), 2 * m), a, b)
  }
  return(ebnm::ebnm_unimodal(x = x,
                             s = s,
                             g_init = g_init,
                             fix_g = fix_g,
                             output = output))
}

prior.bimodal = function(grid_size=40) {
  if(grid_size < 4){
    stop("Bimodal prior grid size must be greater than 4")
  }

  return(as.prior(sign = 1, ebnm.fn = function(x, s, g_init, fix_g, output) {
    bimodal.fn(x, s, g_init, fix_g, output, grid_size)
  }))
}

Y <- readRDS("data/sampleY.rds")
tfl <- system.time(
  fl <- flash(Y, prior.family = c(prior.bimodal(), prior.normal()), verbose = 3)
)
# 4.71 s for 47 iterations


# Restart R again!

devtools::install_github("stephenslab/mixsqp")
library(flashier)

bimodal.fn = function(x, s, g_init, fix_g, output, grid_size) {

  if (is.null(g_init)) {
    m = as.integer(grid_size / 2)
    a <- c(rep(0, m), seq(0.5, 1, length = m))
    b <- c(seq(0, 0.5, length = m), rep(1, m))
    g_init <- ashr::unimix(rep(1/(2 * m), 2 * m), a, b)
  }
  return(ebnm::ebnm_unimodal(x = x,
                             s = s,
                             g_init = g_init,
                             fix_g = fix_g,
                             output = output))
}

prior.bimodal = function(grid_size=40) {
  if(grid_size < 4){
    stop("Bimodal prior grid size must be greater than 4")
  }

  return(as.prior(sign = 1, ebnm.fn = function(x, s, g_init, fix_g, output) {
    bimodal.fn(x, s, g_init, fix_g, output, grid_size)
  }))
}

Y <- readRDS("data/sampleY.rds")
tfl <- system.time(
  fl <- flash(Y, prior.family = c(prior.bimodal(), prior.normal()), verbose = 3)
)
# 19.23 s for 47 iterations
