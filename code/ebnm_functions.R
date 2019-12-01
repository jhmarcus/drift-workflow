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

twopm.fn = function(x, s, g_init, fix_g, output, pi) {
  return(ebnm::ebnm_unimodal(x=x, 
                             s=s, 
                             g_init=ashr::unimix(pi, c(0.0, 1.0), c(0.0, 1.0)), 
                             fix_g=TRUE,
                             output=output))
}

prior.twopm = function(pi) {
  return(as.prior(sign = 1, ebnm.fn = function(x, s, g_init, fix_g, output) {
    twopm.fn(x, s, g_init, fix_g, output, pi = pi)
  }))
}

bimodal.fn =  function(x, s, g_init, fix_g, output) {
  m = 20
  b = seq(1.0, 0.0, length=m)
  a = seq(0.0, 1.0, length=m)
  bimodal_g = ashr:::unimix(rep(1/(2*m), 2*m), c(rep(0, m), b), c(a, rep(1, m)))
  return(ebnm::ebnm_unimodal(x=x, 
                             s=s, 
                             g_init=bimodal_g, 
                             fix_g=FALSE,
                             output=output,
                             control = list(eps = 1e-15)))
}

prior.bimodal = function() {
  return(as.prior(sign=1, ebnm.fn = function(x, s, g_init, fix_g, output) {
    bimodal.fn(x, s, g_init, fix_g, output)
  }))
}