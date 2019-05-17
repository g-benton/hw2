#' Parallel-Processed Jacobi Method
#'
#' Numerically approximates solutions to linear systems like Ax=b
#' @param  A Input Matrix for Ax=b
#' @param  b right-hand side vector for Ax=b
#' @param  n_iters the number of jacobi iterations to run. Degault=100
#' @param  ncores the number of cores to use. Default=1
#' @return Returns x, the approximate solution to Ax=b
#' @import foreach
#' @import doParallel
#' @export
#' @examples
#' A = gen_A(100, 3)
#' x = as.matrix(rep(c(1,0), 50))
#' b = A %*% v
#' jacobi_parallel(A,b, n_iters=100, n_cores=1) # returns approximation to x
jacobi_parallel = function(A, b, n_iters=100, ncores=1){
    n = dim(A)[1]
    x_cur = as.matrix(rep(0, n))
    # print(A %*% x_cur)
    if(ncores > 1){
        doParallel::registerDoParallel(cl)
        for (iter in 1:n_iters) {
            x_list = foreach(i=1:n) %dopar% {
                x = (b[i, 1] - A[i, -i] %*% x_cur[-i])/A[i,i]
            }
            x_cur = unlist(x_list)
        }
        parallel::stopCluster(cl)
    }
    else{
        x_cur = as.matrix(rep(0, n))
        for (iter in 1:n_iters) {
            x_list = foreach(i=1:n) %do% {
                x = (b[i, 1] - A[i, -i] %*% x_cur[-i])/A[i,i]
            }
            x_cur = unlist(x_list)
        }
    }
    return(x_cur)
}

#' Generate a tridiagonal matrix
#'
#' Generates a tridiagonal matrix with ones on the offdiagonals and alpha on the diagonal
#' @param n the size of the matrix
#' @param alpha the value along the diagonal
#' @return Returns A, an n x n tridiagonal matrix
#' @export
gen_A = function(n, alpha){
    A = matrix(0, nrow=n, ncol=n)
    diag(A) = rep(alpha, n)

    del = row(A) - col(A)
    A[abs(del) == 1] = -1
    return(A)
}
