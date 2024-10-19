# Following https://paul-buerkner.github.io/brms/articles/brms_customfamilies.html

library(ggplot2)
library(brms)

data("cbpp", package = "lme4")

ggplot(cbpp, aes(x = as.factor(herd), y = as.integer(incidence))) +
  geom_point() +
  theme_minimal()

fit1 <- brms::brm(
  formula = incidence | trials(size) ~ period + (1 | herd),
  data = cbpp,
  family = binomial()
)

summary(fit1)

beta_binomial2 <- brms::custom_family(
  "beta_binomial2",
  dpars = c("mu", "phi"),
  links = c("logit", "log"),
  lb = c(0, 0),
  ub = c(1, NA),
  type = "int",
  vars = "vint1[n]"
)

stan_funs <- "
  real beta_binomial2_lpmf(int y, real mu, real phi, int T) {
    return beta_binomial_lpmf(y | T, mu * phi, (1 - mu) * phi);
  }
  int beta_binomial2_rng(real mu, real phi, int T) {
    return beta_binomial_rng(T, mu * phi, (1 - mu) * phi);
  }
"

stanvars <- stanvar(scode = stan_funs, block = "functions")

fit2 <- brms::brm(
  incidence | vint(size) ~ period + (1 | herd),
  data = cbpp,
  family = beta_binomial2,
  stanvars = stanvars
)

summary(fit2)
