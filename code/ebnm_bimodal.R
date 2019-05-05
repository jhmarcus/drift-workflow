get_bimodal_grid = function(data, mode, mixcompdist, gridmult=sqrt(2), grange=c(0, 1)){

  mixsd = ashr:::autoselect.mixsd(data, gridmult, mode, grange, mixcompdist)
  mixsd = c(0, mixsd)
  
  k = length(mixsd)
  null.comp = which.min(mixsd) 
  prior = ashr:::setprior("uniform", k, NULL, null.comp)
  pi = ashr:::initpi(k, length(data$x), null.comp)
  
  if (mixcompdist == "+uniform") 
    g = ashr::unimix(pi, rep(mode, k), mode + mixsd)
  if (mixcompdist == "-uniform")
    g = ashr::unimix(pi, mode - mixsd, rep(mode, k))
  
  gconstrain = ashr:::constrain_mix(g, prior, grange, mixcompdist)
  g = gconstrain$g
  a = g$a
  b = g$b
  
  return(list(a=a, b=b))
  
}

get_bimodal_g = function(data, a, b){
  
  K = length(a)
  g = ashr::unimix(rep(1/K, K), a, b) 
  prior = ashr:::setprior("uniform", K, NULL, NULL)
  pi.fit = ashr::estimate_mixprop(data, g, prior, optmethod="mixSQP", control=list(), weights=NULL)
  ghat = pi.fit$g
  
  return(ghat)
  
}

ebnm_bimodal = function(x, s, ash_param, output=NULL) {
  
  data = ashr:::set_data(as.vector(x), as.vector(s), ashr:::add_etruncFUN(ashr::lik_normal()), 0)
  grid0 = get_bimodal_grid(data, 0, "+uniform")
  grid1 = get_bimodal_grid(data, 1, "-uniform")
  a = c(grid0$a, grid1$a)
  b = c(grid0$b, grid1$b)
  ghat = get_bimodal_g(data, a, b)
  ash_param$g = ghat
  ash_param$fixg = TRUE
  ash_param$outputlevel = 5

  a = do.call(ashr::ash,
              c(list(betahat = as.vector(x), sebetahat = as.vector(s)),
                ash_param))

  if (is.null(a$flash_data$postmean)) {
    stop(paste("ashr is not outputting flashr data in the right format.",
               "Maybe ashr needs updating to latest version?"))
  } else {
    out = a$flash_data
  }
  
  return(out)
}