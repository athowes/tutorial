library(ggplot2)
library(brms)

y <- rnorm(n = 1000, mean = 10, sd = 2)
plot(y)

y <- y[y < 10]
y <- y[y > 6]
plot(y)

df <- data.frame(y = y)

fit <- brms::brm(formula = y ~ 1, family = gaussian(), data = df)

fit_trun_oracle <- brms::brm(formula = trunc(y, lb = 6, ub = 10) ~ 1, family = gaussian(), data = df)
fit_trun_oracle_ub <- brms::brm(formula = trunc(y, ub = 10) ~ 1, family = gaussian(), data = df)
fit_trun_oracle_lb <- brms::brm(formula = trunc(y, lb = 6) ~ 1, family = gaussian(), data = df)

fit
fit_trun_oracle
fit_trun_oracle_ub
fit_trun_oracle_lb
