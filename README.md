README
================
Greg Benton
5/7/2019

Solve OLS
---------

``` r
library(HW2)
print("hey")
```

    ## [1] "hey"

ALGO Leverage
-------------

``` r
dat = gen_dat(500)
x = dat[[1]]
y = dat[[2]]
algo_leverage(x, y, r=20, subsample='lev')
```

    ## 
    ## Call:
    ## lm(formula = y[samp] ~ x[samp], weights = 1/lev_probs[samp])
    ## 
    ## Coefficients:
    ## (Intercept)      x[samp]  
    ##     -0.2397      -0.5895

Elastic Net Coordinate Descent
------------------------------

``` r
dat = gen_elnet_data(50)
X = dat[[1]]
y = dat[[2]]

beta = elnet_coord(X, y, alpha=1, lambda = 1, n_iters = 100)
print(beta)
```

    ##  [1]  1.4515066  0.0000000 -1.5261654  0.0000000  0.4455533  0.0000000
    ##  [7] -0.6435084  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
    ## [13]  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
    ## [19]  0.0000000  0.0000000
