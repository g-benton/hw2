README
================
Greg Benton
5/7/2019

Installation Instructions:
--------------------------

``` r
library(devtools)
install_github("g-benton/hw2") # install the package
```

    ## Warning in strptime(x, fmt, tz = "GMT"): unknown timezone 'zone/tz/2019a.
    ## 1.0/zoneinfo/America/New_York'

    ## Downloading GitHub repo g-benton/hw2@master
    ## from URL https://api.github.com/repos/g-benton/hw2/zipball/master

    ## Installing HW2

    ## '/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file  \
    ##   --no-environ --no-save --no-restore --quiet CMD INSTALL  \
    ##   '/private/var/folders/21/gc5lp3k164lf7q26pzxcsqq40000gn/T/RtmpOaB1Fm/devtoolsa6253dfe50fd/g-benton-hw2-98da1b3'  \
    ##   --library='/Library/Frameworks/R.framework/Versions/3.4/Resources/library'  \
    ##   --install-tests

    ## 

``` r
library(HW2) # load into the workspace
```

Solve OLS
---------

First generate some simple data to test with: 100x100 matrix with 4's on diagonal and 1's on off diagonal with true solution vector (1,0,1,0,1...):

``` r
A = gen_A(100, 4)
x = as.matrix(rep(c(1,0), 50))
b = A %*% x
```

Now using *A* and *b* approximate *x*. To run in parallel just specify ncores&gt;1.

``` r
approx_x = jacobi_parallel(A, b, n_iters=100, ncores=1)
print(paste("Error = ", norm(x - approx_x, 'f')))
```

    ## [1] "Error =  0"

ALGO Leverage
-------------

A data generator that generates data from the same setting as Ma and Sun (2014) <https://onlinelibrary.wiley.com/doi/full/10.1002/wics.1324> is included as .

First generate *x*, *y* data and unpack the list,

``` r
dat = gen_dat(500)
x = dat[[1]]
y = dat[[2]]
```

Now run the algorithm to return the sub-sampled model. *r* specifices the size of the subsample, and *s**u**b**s**a**m**p**l**e* specifies the type of sampling to use, `lev' for leverage based  or`unif' for uniform sampling.

``` r
algo_leverage(x, y, r=20, subsample='lev')
```

    ## 
    ## Call:
    ## lm(formula = y[samp] ~ x[samp], weights = 1/lev_probs[samp])
    ## 
    ## Coefficients:
    ## (Intercept)      x[samp]  
    ##    -0.04312     -1.09781

Elastic Net Coordinate Descent
------------------------------

Again there is a small data generator to generate data as we did in HW1, but any multiple linear regression problem will work

``` r
dat = gen_elnet_data(50)
X = dat[[1]]
y = dat[[2]]
```

Now run to perform coordinate descent for an elastic net. *X* and *y* are the predictors and response for the regression problem, and specify the proportion of the

``` r
beta = elnet_coord(X, y, alpha=1, lambda = 1, n_iters = 100)
print(beta)
```

    ##  [1]  1.6941360  0.0000000 -1.4507016  0.0000000  0.1106666  0.1730622
    ##  [7] -0.2514530  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
    ## [13]  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
    ## [19]  0.0000000  0.0000000

The true *β* vector is (2, 0, −2, 0, 1, 0, −1, 0, ...)∈ℝ<sup>20</sup>
