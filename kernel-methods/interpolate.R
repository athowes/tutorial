#' Kernel interpolation
#' Using representer theorem

library(tidyverse)

x <- c(1, 2, 3, 4, 5)
y <- rnorm(5)

df <- data.frame(x, y)

plot <- ggplot(df, aes(x = x, y = y)) + 
  geom_point() +
  theme_minimal()

#' Interpolate these points subject to minimising the norm of the function
#' Note that the "minimising the norm" only applies here such that we can discard
#' the orthogonal part not in the finite dimensional subspace spanned by our features
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

#' Inversion is O(n^3)
alpha <- solve(K) %*% y

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

#' The norm of alpha is very large here! Better to do some regularlisation
alpha