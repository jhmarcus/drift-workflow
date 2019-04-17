positive_part = function(A){
  A_plus = (abs(A) + A) / 2
  return(A_plus)
}


negative_part = function(A){
  A_negative = (abs(A) - A) / 2
  return(A_negative)
}


convex_nmf = function(X, K, init="kmeans", n_iter, eps=1e-4, n_print=200){
  
  n = ncol(X)
  p = nrow(X)
  
  if(init == "kmeans"){
    k_fit = kmeans(t(X), K)
    H = matrix(0, nrow=n, ncol=K)
    Dinv = matrix(0, nrow=K, ncol=K)
    for(k in 1:K){
      H[, k] = as.integer(k_fit$cluster == k)
      Dinv[k, k] = 1.0 / sum(H[, k])
    }
    G = H + .2
    W = (H + .2) %*% Dinv
  }
  
  XtX = t(X) %*% X
  XtXp = positive_part(XtX) 
  XtXn = negative_part(XtX) 
  
  rss = rep(NA, n_iter+1)
  rss[1] = Inf
  for(i in 2:(n_iter+1)){
    
    # update G
    XtXpW = XtXp %*% W
    XtXnW = XtXn %*% W
    GWt = G %*% t(W)
    gnum = XtXpW + (GWt %*% XtXnW)
    gdenom = XtXnW + (GWt %*% XtXpW) 
    G = G * sqrt(gnum / gdenom)
    
    # update W
    XtXpG = XtXp %*% G
    XtXnG = XtXn %*% G
    WGtG = W %*% t(G) %*% G
    wnum = XtXpG + (XtXn %*% WGtG)
    wdenom = XtXnG + (XtXp %*% WGtG) 
    W = W * sqrt(wnum / wdenom)
    
    Xhat = X %*% W %*% t(G)
    rss[i] = sum((X - Xhat)^2)
    delta = rss[i-1] - rss[i]
    if(delta <= eps){
      break
    }
    
    if(i %% n_print == 0){
      print(paste0("iteration=", i, " | delta_rss=", delta))
    }
    
  }
  
  res = list(W=W, G=G, Xhat=Xhat, rss=rss[!is.na(rss)])
  return(res)
}
