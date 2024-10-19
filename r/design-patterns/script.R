# Something to go over before reading e.g. Design Patterns
# https://www.inwt-statistics.com/blog/design-patterns-in-r-517

# Currying is the technique of translating a function that takes multiple arguments
# into a sequence of families of functions, each taking a single argument. 

# Recall function is new to me!
fp <- function(f, x, converged, ...) {
  value <- f(x, ...)
  if (converged(x, value)) value
  else Recall(f, value, converged, ...) 
}

fpsqrt <- function(x, p) p / x

converged <- function(x, y) all(abs(x - y) < 0.001)

fp(fpsqrt, 2, converged, p = 2)

averageDamp <- function(fun) {
  function(x, ...) (x + fun(x, ...)) / 2
}

fp(averageDamp(fpsqrt), 2, converged, p = 2)
sqrt(2)

printValue <- function(fun) {
  function(x, ...) {
    cat(x, "\n")
    fun(x, ...)
  }
}

fp(printValue(averageDamp(fpsqrt)), 2, converged, p = 2)

# There is this issue about need ... in every function: I've experienced this

fp(averageDamp(function(x) fpsqrt(x, p = 2)), 2, converged)

# functional and pryr functions for currying

# pryr superseded by rlang for low-level R programming, lobstr for object sizes & comparison, and sloop for OOP tools

# A closure is a function which has an environment associated to it

fpsqrt <- function(p) {
  function(x) p / x
}

fp(averageDamp(fpsqrt(2)), 2, converged)

# Cache

nr <- function(X, y) {
  function(beta) beta - solve(-crossprod(X)) %*% crossprod(X, y - X %*% beta)
}

set.seed(1)
X <- cbind(1, 1:10)
y <- X %*% c(1, 2) + rnorm(10)

fp(printValue(averageDamp(nr(X, y))), c(1, 2), converged)

stats::lm.fit(X, y)$coefficients

nr <- function(X, y) {
  # f1 relies on values in its scope
  f1 <- function(beta) Xy - XX %*% beta
  
  Xy <- crossprod(X, y)
  XX <- crossprod(X)
  f2inv <- solve(-XX)
  
  function(beta) beta - f2inv %*% f1(beta)
}

fp(averageDamp(nr(X, y)), c(1, 2), converged)

