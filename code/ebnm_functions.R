library(ashr)
library(ebnm)

fixnormal.fn = function(x, s, g_init, fix_g, output, pi) {
  return(ebnm::ebnm_unimodal(x=x, 
                             s=s, 
                             g_init=ashr::normalmix(c(0.0, 1.0), c(0.0, 0.0), c(0.0, 1.0)), 
                             fix_g=TRUE,
                             output=output))
}

prior.fixnormal = function(pi) {
  return(as.prior(sign = 0, ebnm.fn = function(x, s, g_init, fix_g, output) {
    fixnormal.fn(x, s, g_init, fix_g, output, pi = pi)
  }))
}

fixtwopm.fn = function(x, s, g_init, fix_g, output, pi) {
  return(ebnm::ebnm_unimodal(x=x, 
                             s=s, 
                             g_init=ashr::unimix(pi, c(0.0, 1.0), c(0.0, 1.0)), 
                             fix_g=TRUE,
                             output=output))
}

prior.fixtwopm = function(pi) {
  return(as.prior(sign = 1, ebnm.fn = function(x, s, g_init, fix_g, output) {
    fixtwopm.fn(x, s, g_init, fix_g, output, pi = pi)
  }))
}