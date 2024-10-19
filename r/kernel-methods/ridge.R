#' Kernel ridge regression
#' Using representer theorem

library(tidyverse)

x <- c(1, 2, 3, 4, 5)
y <- rnorm(5)

df <- data.frame(x, y)

plot <- ggplot(df, aes(x = x, y = y)) + 
  geom_point() +
  theme_minimal()

#' Solve the minimiser f in some RKHS H of a sum of squares regularised by a
#' ridge penalty i.e. sum((f(x_i) - y_i)^2) + lambda ||f||^2
k <- function(x1, x2) {
  exp(-x1 * x2)
}

K <- matrix(nrow = 5, ncol = 5)

#' O(n^2 * d) where d is the order of kernel computation
for(i in 1:5) {
  for(j in 1:5) {
    K[i, j] <- k(x[i], x[j])
  }
}

lambda <- 0.1

#' Inversion is O(n^3)
alpha <- solve(lambda * diag(5) + K) %*% y

#' Representer
f <- function(z) {
  sum(alpha * k(z, x))
} 

z <- seq(1, 5, by = 0.1)
fz <- c()

for(i in 1:length(z)) {
  fz[i] <- f(z[i])
}

plot +
  geom_line(data = data.frame(z = z, fz = fz), aes(x = z, y = fz))