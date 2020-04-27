# trace of a matrix
tr <- function(A){
    return(sum(diag(A)))
}


# log determinant of a matrix
logdet <- function(A){
    return(log(det(A)))
}


# helper used for computing low-rank inverse
comp_kinv <- function(tau, L, D){
    n_factors <- ncol(L)
    dinv <-  1.0 / diag(D) 
    Kinv <- solve(diag(dinv) + tau * t(L) %*% L)
    return(Kinv)
}

# compute the negative log-likelihood taking advantage of low-rank structure
comp_neg_loglik <- function(sigma2, S, L, D, p){
    n <- nrow(S)
    tau <- 1.0 / sigma2
    Kinv <- comp_kinv(tau, L, D)
    KinvLt <- Kinv %*% t(L)
    SOmega <- (tau * S) - (tau^2) * (S %*% L) %*% KinvLt
    Omega <- (tau * diag(n)) - (tau^2) * L %*% KinvLt
    
    tr_term <- tr(SOmega)
    logdet_term <- logdet(Omega)
    neg_loglik <- .5 * p * (tr_term - logdet_term)
    
    return(neg_loglik)
}

# wrapper around comp_neg_loglik to compute the negative log-likelihood using
# a vectorized version of the loadings and prior variance matricies
comp_neg_log_lik_theta <- function(theta, sigma2, S, n_factors, p, lamb){
    n <- nrow(S)
    tau <- 1.0 / sigma2
    ell <- theta[1:(n*n_factors)]
    L <- matrix(ell, nrow=n, ncol=n_factors)
    D <- diag(theta[(n*n_factors+1):length(theta)])
    neg_loglik <- comp_neg_loglik(sigma2, S, L, D, p) - (lamb - 1)  * sum((log(ell) + log(1.0 - ell)))
    return(neg_loglik)
}


# compute the gradient of the loadings matrix using a vectorized input
comp_grad_ell <-  function(L, D, tau, S, n_factors, p){
    n <- nrow(S)
    Kinv <- comp_kinv(tau, L, D)
    Omega <- (tau * diag(n)) - (tau^2 * L) %*% Kinv %*% t(L)
    OmegaL <- Omega %*% L
    gradL <- -p * (Omega %*% (S %*% OmegaL) - OmegaL) %*% D  
    grad_ell <- as.vector(gradL)
    return(grad_ell)
}

comp_grad_d <- function(L, D, tau, S, n_factors, p){
    n <- nrow(S)
    Kinv <- comp_kinv(tau, L, D)
    Omega <- (tau * diag(n)) - (tau^2 * L) %*% Kinv %*% t(L)
    OmegaL <- Omega %*% L
    R <- S - L %*% D %*% t(L) + (1.0 / tau) * diag(n)
    grad_d <- diag(-(.5 * p) * t(OmegaL) %*% R %*% OmegaL)
    return(grad_d)
}


comp_grad_theta <- function(theta, sigma2, S, n_factors, p, lamb){
    ell <- theta[1:(n*n_factors)]
    L <- matrix(theta[1:(n*n_factors)], nrow=n, ncol=n_factors)
    D <- diag(theta[(n*n_factors + 1):length(theta)])
    tau <- 1/sigma2
    grad_ell <- comp_grad_ell(L, D, tau, S, n_factors, p) - (lamb - 1) * sum((1 / ell) - (1 / (ell - 1)))
    grad_d <- comp_grad_d(L, D, tau, S, n_factors, p)
    grad_theta <- c(grad_ell, grad_d)
    return(grad_theta)
}

nnfa2 <- function(Y, L, D, sigma2, 
                  lamb=0.0,
                  lower_ell=1e-8, upper_ell=1-1e-8,
                  lower_d=1e-8, upper_d=5,
                  control=list(maxit=15)){
    # force control to report the nll every iteration
    control$REPORT <- 1
    control$trace <- 1
    
    # number of samples, features, and factors
    n <- nrow(Y)
    p <- ncol(Y)
    n_factors <- ncol(L)  
    
    # sample covariance matrix
    S <- Y %*% t(Y) / p
    
    # vectorize 
    ell_init <- as.vector(L)
    d_init <- diag(D)
    theta_init <- c(ell_init, d_init)
    lower <- c(rep(lower_ell, length(ell_init)), rep(lower_d, length(d_init)))
    upper <- c(rep(upper_ell, length(ell_init)), rep(upper_d, length(d_init)))
    
    # run bounded L-BFGS
    f <- optim(par=theta_init, 
               fn=comp_neg_log_lik_theta, 
               gr=comp_grad_theta, 
               method="L-BFGS-B",
               lower=lower, 
               upper=upper,
               control=control,
               sigma2=sigma2, 
               lamb=lamb,
               S=S, 
               n_factors=n_factors, 
               p=p)
    
    if(f$convergence != 0){
        warning("L-BFGS-B did not converge")
    }
    
    f$L <- matrix(f$par[1:(n*n_factors)], nrow=n, ncol=n_factors)
    f$D <- diag(f$par[(n*n_factors + 1):length(f$par)])
    return(f)
}



n_per_pop <- 20
pops <- c(rep("Pop1", n_per_pop), rep("Pop2", n_per_pop))
sigma_e <- 1.0
sigma_b <- c(1.0, 1.0, 1.0)
p = 10000
sim_res <- drift.alpha::two_pop_tree_sim(n_per_pop, p, sigma_e, sigma_b)
Y <- sim_res$Y
n <- nrow(Y)
p <- ncol(Y)

K <- 2
Linit <- matrix(runif(n*K), nrow=n, ncol=K)
Dinit <- diag(K)
res <- nnfa2(Y, Linit, Dinit, sigma2=sigma_e^2, lamb=10, 
             control=list(maxit=1000))
plot_loadings(res$L, pops)


