# https://future.futureverse.org/articles/future-1-overview.html

# Evaluate R expressions async using various resources

v <- {
  cat("Hello world!\n")
  3.14
}

library(future)

v %<-% {
  cat("Hello world!\n")
  3.14
}

# future uses %<-% where as base R uses <-

plan(multisession)
