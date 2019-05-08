#' Algorithmic Leveraging for Linear Regression
#'
#' Computes estimate of SLR coefficient using subsampling
#' @param  x predictor matrix (n x p)
#' @param  y response variable (n x 1)
#' @param  alpha Ratio of elastic net (alpha=1 corresponds to lasso)
#' @param  lambda regularization weight. Default=1
#' @param  n_iters number of update iterations. Default=100
#' @return Returns regression estimates (p x 1)
#' @export
#' @examples
#' dat = elnet_data_gen(n)
#' X = dat[[1]]
#' y = dat[[2]]
#' elnet_coord(x, y, alpha=0.8, lambda=2)
elnet_coord = function(X, y, alpha=0.5, lambda=1, n_iters=100){
  resid_ij = function(X, y, beta, i, j){
     res = y[i] - X[i, ] %*% beta  + X[i, j]*beta[j]
     return(res)
  }

  soft_thresh = function(z, mu){
      return(sign(z) * max(abs(z) - mu, 0))
  }
  update = function(X, y, beta, lambda, alpha, j){
      n = dim(X)[1]
      xj = X[ , j]

      ## everything numerator related ##
      phi = 0
      for (ii in 1:n) {
          phi = phi + X[ii,j]*resid_ij(X, y, beta, ii, j)
      }
      phi = phi*2/n
      numerator = soft_thresh(phi, lambda*alpha)

      ## denominator ##
      denominator = 2/n*t(xj) %*% xj + lambda * (1 - alpha)

      return(numerator/denominator)
  }
  # actual script #
  p = dim(X)[2]

  beta_est = array(0, dim=p)
  beta_temp = beta_est
  for (iter in 1:n_iters) {
      for (j in 1:p) {
         beta_est[j] = update(X, y, beta_est, lambda, alpha, j)
      }

  }

  return(beta_est)
}

#' Generates Data like used in HW1 to run elnet_coord
#'
#' generates X (n x 20) and y (n x 1) with fixed true betas
#' @param  n number of data points to use
#' @return Returns list(x, y)
#' @export
#' @examples
#' dat = gen_elnet_data(20)
#' X = dat[[1]]
#' y = dat[[2]]

gen_elnet_data = function(n=50){
    p = 20
    Sigma = diag(rep(1, p))
    Sigma[1, 2] = 0.8
    Sigma[2, 1] = 0.8
    Sigma[5, 6] = 0.8
    Sigma[6, 5] = 0.8
    mu = rep(0, p)
    X = MASS::mvrnorm(n, mu=mu, Sigma=Sigma)
    true_beta = c(2, 0, -2, 0, 1, 0, -1, 0, rep(0, 12))
    y = X %*% true_beta + rnorm(n)
    return(list(X, y))
}
