#' Algorithmic Leveraging for Linear Regression
#'
#' Computes estimate of SLR coefficient using subsampling
#' @param  x predictor variable
#' @param  y response variable
#' @param  subsample Should subsamples be taken uniformly or according to leverage
#'    scores? Options are 'unif' and 'lev'. Default='unif'
#' @param  r Size of subsample, defaults to ~10 percent of data
#' @return Returns lm class predicted
#' @export
#' @examples
#' algo_leverage(x, y, subsample='lev', r=10)
algo_leverage = function(x, y, subsample='unif', r=0){
  n = length(x)

  if(r == 0){
    r = floor(n/10)
  }

  if(subsample=='lev'){
    X = cbind(rep(1, n), x)
    H = X %*% solve(t(X) %*% X) %*% t(X)
    lev = diag(H)
    lev_probs = lev/sum(lev)
    samp = sample(1:n, r, prob=lev_probs)
    model = lm(y[samp] ~ x[samp], weights=1/lev_probs[samp])

  } else if (subsample=='unif') {
    samp = sample(1:n, r)
    model = lm(y[samp] ~ x[samp])

  } else {
    print("Make sure subsample is either 'unif' or 'lev'!")
    return(0)
  }

  return(model)
}


#' A helper function to generate data for algorithmic leveraging
#'
#' Generates noisey x,y data where y = -x + noise and x ~ t-distribution
#' @param  n number of data points
#' @param  df degrees of freedom for t-distribution over x. Default=6
#' @return Returns list(x, y)
#' @export
#' @examples
#' gen_dat(n=10, df=6)
gen_dat = function(n, df=6){
  x = rt(n, df=df)
  eps = rnorm(n, 0, 1)
  y = -x + eps
  return( list(x, y) )
}
