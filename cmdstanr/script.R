# I've been using rstan this whole time but heard that cmdstanr is better

# https://mc-stan.org/cmdstanr/articles/cmdstanr.html

# install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

library(cmdstanr)
library(posterior)
library(bayesplot)

# install_cmdstan(cores = 2)

check_cmdstan_toolchain()
cmdstan_path()
cmdstan_version()

file <- file.path(cmdstan_path(), "examples", "bernoulli", "bernoulli.stan")
mod <- cmdstan_model(file)

mod$print()
mod$exe_file()

data <- list(N = 10, y = c(0, 1, 0, 0, 0, 0, 0, 0, 0, 1))
lengths(data)

fit <- mod$sample(
  data = data,
  seed = 123,
  chains = 4,
  parallel_chains = 4,
  refresh = 500
)

fit$summary()
fit$summary("theta", pr_lt_half = ~ mean(. <= 0.5))

fit$summary(
  variables = NULL,
  posterior::default_summary_measures(),
  extra_quantiles = ~posterior::quantile2(., probs = c(.0275, .975))
)

fit$cmdstan_summary()

draws_array <- fit$draws(format = "array")
str(draws_array)

draws_df <- fit$draws(format = "df")
str(draws_df)

draws_df_2 <- as_draws_df(draws_array)
identical(draws_df, draws_df_2)

mcmc_hist(fit$draws("theta"))
mcmc_rank_overlay(fit$draws("theta"))
mcmc_rank_ecdf(fit$draws("theta"))
mcmc_rank_hist(fit$draws("theta"))

str(fit$sampler_diagnostics())
str(fit$sampler_diagnostics(format = "df"))

# I know a little about what a divergent transition is but not much about what
# maximum treedepth or "E-BFMI" (expected Bayesian fraction of missing information).

fit$diagnostic_summary()

fit_with_warning <- cmdstanr_example("schools")
diagnostics <- fit_with_warning$diagnostic_summary()
print(diagnostics)

fit_with_warning$cmdstan_diagnose()

stanfit <- rstan::read_stan_csv(fit$output_files())

fit_mle <- mod$optimize(data = data, seed = 123)
fit_mle$print()
fit_mle$mle("theta")

mcmc_hist(fit$draws("theta")) +
  vline_at(fit_mle$mle("theta"), size = 1.5)
