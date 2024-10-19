library(ggplot2)

mu <- 1.2
alpha <- 0.6
beta <- 0.8
T <- 10

# Initialize other variables that change through realizations
bigTau <- vector('numeric')
bigTau <- c(bigTau, 0)
s <- 0
n <- 0
lambda_vec_accepted <- c(mu)

while (s < T) {
  sum_over_big_Tau <- 0
  for (i in c(1:length(bigTau))) {
    sum_over_big_Tau <- sum_over_big_Tau + alpha * exp(- beta * (s - bigTau[i]))
  }
  
  lambda_bar <- mu + sum_over_big_Tau
  u <- runif(1)
  w <- - log(u) / lambda_bar
  s <- s + w
  D <- runif(1)
  
  sum_over_big_Tau <- 0
  
  for (i in c(1:length(bigTau))) {
    sum_over_big_Tau <- sum_over_big_Tau + alpha * exp(- beta * (s - bigTau[i]))
  }
  lambda_s <- mu + sum_over_big_Tau
  
  if (D*lambda_bar <= lambda_s ) {
    lambda_vec_accepted <- c(lambda_vec_accepted, lambda_s)
    n <- n + 1
    t_n <- s
    bigTau <- c(bigTau, t_n)
  }
}

df <- data.frame(x = bigTau, y = lambda_vec_accepted)

ggplot(df, aes(x = bigTau, y = lambda_vec_accepted)) +
  geom_line() +
  theme_minimal()
