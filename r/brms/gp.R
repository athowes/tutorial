# Notes on https://michael-franke.github.io/Bayesian-Regression/practice-sheets/10c-Gaussian-processes.html

library(tidyverse)
library(brms)
library(rstan)
library(rstanarm)
library(remotes)
library(tidybayes)
library(bridgesampling)
library(shinystan)
library(mgcv)

project_colors <- cspplot::list_colors() |> pull(hex)

covmatrix <- function(x, sigma_f, lambda, N) {
  K = matrix(0, nrow = N, ncol = N)
  for (i in 1:N) {
    for (j in 1:N) {
      K[i, j] = sigma_f^2 * exp(sqrt((i - j)^2) / (-2 * lambda))
    }
  }
  return(K)
}

simulate_gp <- function(x = seq(0,10, by = 0.1), intercept = 0, slope = 1,
                        sigma = 1, sigma_f = 0.5, lambda = 100, seed = NULL) {
    if (! is.null(seed)) set.seed(seed)
    N <- length(x)
    eta <- intercept + slope * x
    K <- covmatrix(x, sigma_f, lambda, N)
    epsilon_gp <- mvtnorm::rmvnorm(n = 1, mean = rep(0, N), sigma = K)[1, ]
    mu <- epsilon_gp + eta
    y <- rnorm(N, mu, sigma)
    tibble::tibble(x, eta, mu, y) 
}

plot_gp_simulation <- function(df) {
  ggplot(df, aes(x = x, y = eta)) + 
    geom_line(color = project_colors[1], size = 1.25) +
    geom_line(aes(y = mu), color = project_colors[2], linewidth = 1.25) +
    geom_point(aes(y = y), color = project_colors[3], alpha = 0.7, size = 1.2)
}

df <- simulate_gp(x = seq(-1, 1, length.out = 100), lambda = 2, sigma = 0.01)

plot_gp_simulation(df) + theme_minimal()

fit <- brms::brm(
  formula = y ~ 1 + x + gp(x),
  data = df,
  iter = 4000
)

conditional_effects <- conditional_effects(fit, plot = FALSE)

ggplot(conditional_effects$x, aes(x = x, y = estimate__, ymin = lower__, ymax = upper__)) +
  geom_line(col = project_colors[5]) +
  geom_ribbon(alpha = 0.5, fill = project_colors[5]) +
  geom_point(data = df, aes(x = x, y = y), inherit.aes = FALSE, color = project_colors[3]) +
  theme_minimal()

# Do have approximate GP with basis functions implemented
# https://github.com/paul-buerkner/brms/issues/540

fit_approx <- brms::brm(
  formula = y ~ 1 + x + gp(x, k = 5),
  data = df,
  iter = 4000
)

conditional_effects <- conditional_effects(fit_approx, plot = FALSE)

plot(conditional_effects)
