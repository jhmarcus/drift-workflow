

# Negative log marginal likelihood
nll = function(pi, data){
  betahat = data[[1]]
  s = data[[2]]
  liks = (1.0-pi) * dnorm(betahat, mean=0, sd=s) + pi * dnorm(betahat, mean=1, sd=s) 
  loglik = sum(log(liks))
  return(-loglik)
}

# Estimate g by minmizing nll
est_pi = function(betahat, s){
  fit = optim(par=c(.5), 
              fn=nll, 
              data=list(betahat, s), 
              method="Brent", 
              lower=0, 
              upper=1)
  pihat = fit$par
  loglik = -fit$value
  return(list(pihat=pihat, loglik=loglik))
}

# Estimate the post using bayes rule and plug in of pihat mle
est_post = function(betahat, s, pihat){
  c0 = dnorm(betahat, mean=0, sd=s) * (1 - pihat)
  c1 = dnorm(betahat, mean=1, sd=s) * pihat
  pm = c1 / (c0 + c1)
  return(pm)
}

ebnm.bern = function(x, s, ebnm.param=NULL) {

  pi_res = est_pi(x, s)
  pihat = pi_res$pihat
  loglik = pi_res$loglik
  PosteriorMean = est_post(x, s, pihat)
  PosteriorMean2 = PosteriorMean * (1.0 - PosteriorMean)
  res = list(postmean=PosteriorMean, 
             postmean2=PosteriorMean2,
             penloglik=loglik,
             fitted_g=NULL)  
  return(res)
  
}

