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

fit_map <- mod$optimize(
  data = data,
  jacobian = TRUE,
  seed = 123
)

fit_laplace <- mod$laplace(
  mode = fit_map,
  draws = 4000,
  data = data,
  seed = 123,
  refresh = 1000
)

mcmc_hist(fit_laplace$draws("theta"), binwidth = 0.025)

fit_vb <- mod$variational(
  data = data,
  seed = 123,
  draws = 4000
)

mcmc_hist(fit_vb$draws("theta"), binwidth = 0.025)

fit_pf <- mod$pathfinder(
  data = data,
  seed = 123,
  draws = 4000
)

mcmc_hist(fit_pf$draws("theta"), binwidth = 0.025)

fit$save_object(file = "fit.rds")

# The RStan interface (rstan package) is an in-memory interface to Stan and relies
# on R packages like Rcpp and inline to call C++ code from R. On the other hand,
# the CmdStanR interface does not directly call any C++ code from R

# Running Stan on the GPU with OpenCL
# https://mc-stan.org/cmdstanr/articles/opencl.html
# https://mc-stan.org/docs/stan-users-guide/opencl.html
# https://arxiv.org/pdf/1907.01063.pdf

# Generate some fake data
n <- 250000
k <- 20
X <- matrix(rnorm(n * k), ncol = k)
y <- rbinom(n, size = 1, prob = plogis(3 * X[,1] - 2 * X[,2] + 1))
data <- list(k = k, n = n, y = y, X = X)

mod_cl <- cmdstan_model("bernoulli_logit_glm.stan", cpp_options = list(stan_opencl = TRUE))
