# https://sethrf.com/files/fast-hierarchical-GPs.pdf
# https://github.com/stan-dev/posteriordb/blob/793622ae72ac73da88f6bdc0a8233cf196139253/posterior_database/models/stan/kronecker_gp.stan

library(kernlab)

eps <- 1e-8
n = 200
space <- seq(-2, 2, length.out = n)
time <- space
K1 <- kernelMatrix(rbfdot(4), as.matrix(space))
K2 <- kernelMatrix(rbfdot(1), as.matrix(time))
L1 <- chol(K1 + eps * diag(n))
L2 <- chol(K2 + eps * diag(n))
v <- rnorm(n * n)
y <- as.numeric(matrix(t(t(L2) %*% matrix(t(t(L1) %*% matrix(v, n, n)), n, n)), n * n, 1))
y <- y + rnorm(n * n, sd = .1) # Add spherical noise
data <- list(n1 = length(space), n2 = length(time), x1 = space, x2 = time, y = as.numeric(y))

plot(y)
