library(primarycensored)
library(cmdstanr)
library(ggplot2)
library(dplyr)

set.seed(123) # For reproducibility

# Define the true distribution parameters
n <- 2000
meanlog <- 1.5
sdlog <- 0.75

# Generate varying pwindow, swindow, and obs_time lengths
pwindows <- sample(1:2, n, replace = TRUE)
swindows <- sample(1:2, n, replace = TRUE)
obs_times <- sample(8:10, n, replace = TRUE)

# Function to generate a single sample
generate_sample <- function(pwindow, swindow, obs_time) {
  rpcens(
    1, rlnorm,
    meanlog = meanlog, sdlog = sdlog,
    pwindow = pwindow, swindow = swindow, D = obs_time
  )
}

# Generate samples
samples <- mapply(generate_sample, pwindows, swindows, obs_times)

# Create initial data frame
delay_data <- data.frame(
  pwindow = pwindows,
  obs_time = obs_times,
  observed_delay = samples,
  observed_delay_upper = samples + swindows
) |>
  mutate(
    observed_delay_upper = pmin(obs_time, observed_delay_upper)
  )

head(delay_data)

# Aggregate to unique combinations and count occurrences
delay_counts <- delay_data |>
  summarise(
    n = n(),
    .by = c(pwindow, obs_time, observed_delay, observed_delay_upper)
  )

head(delay_counts)

# Compare the samples with and without secondary censoring to the true
# distribution
# Calculate empirical CDF
empirical_cdf <- ecdf(samples)

# Create a sequence of x values for the theoretical CDF
x_seq <- seq(min(samples), max(samples), length.out = 100)

# Calculate theoretical CDF
theoretical_cdf <- plnorm(x_seq, meanlog = meanlog, sdlog = sdlog)

# Create a long format data frame for plotting
cdf_data <- data.frame(
  x = rep(x_seq, 2),
  probability = c(empirical_cdf(x_seq), theoretical_cdf),
  type = rep(c("Observed", "Theoretical"), each = length(x_seq)),
  stringsAsFactors = FALSE
)

# Plot
ggplot(cdf_data, aes(x = x, y = probability, color = type)) +
  geom_step(linewidth = 1) +
  scale_color_manual(
    values = c(Observed = "#4292C6", Theoretical = "#252525")
  ) +
  geom_vline(
    aes(xintercept = mean(samples), color = "Observed"),
    linetype = "dashed", linewidth = 1
  ) +
  geom_vline(
    aes(xintercept = exp(meanlog + sdlog^2 / 2), color = "Theoretical"),
    linetype = "dashed", linewidth = 1
  ) +
  labs(
    title = "Comparison of Observed vs Theoretical CDF",
    x = "Delay",
    y = "Cumulative Probability",
    color = "CDF Type"
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom"
  )

writeLines(
  "data {
    int<lower=0> N;  // number of observations
    vector[N] y;     // observed delays
    vector[N] n;     // number of occurrences for each delay
  }
  parameters {
    real mu;
    real<lower=0> sigma;
  }
  model {
    // Priors
    mu ~ normal(1, 1);
    sigma ~ normal(0.5, 1);

    // Likelihood
    target += n .* lognormal_lpdf(y | mu, sigma);
  }",
  con = file.path(tempdir(), "naive_lognormal.stan")
)

naive_model <- cmdstan_model(file.path(tempdir(), "naive_lognormal.stan"))

naive_fit <- naive_model$sample(
  data = list(
    # Add a small constant to avoid log(0)
    y = delay_counts$observed_delay + 1e-6,
    n = delay_counts$n,
    N = nrow(delay_counts)
  ),
  chains = 4,
  parallel_chains = 4,
  refresh = ifelse(interactive(), 50, 0),
  show_messages = interactive()
)

naive_fit

writeLines(
  "
  functions {
    #include primarycensored.stan
    // These functions are required for the primarycensored_lpdf function
    #include primarycensored_ode.stan
    #include primarycensored_analytical_cdf.stan
    #include expgrowth.stan
  }
  data {
    int<lower=0> N;  // number of observations
    array[N] int<lower=0> y;     // observed delays
    array[N] int<lower=0> y_upper;     // observed delays upper bound
    array[N] int<lower=0> n;     // number of occurrences for each delay
    array[N] int<lower=0> pwindow; // primary censoring window
    array[N] int<lower=0> D; // maximum delay
  }
  transformed data {
    array[0] real primary_params;
  }
  parameters {
    real mu;
    real<lower=0> sigma;
  }
  model {
    // Priors
    mu ~ normal(1, 1);
    sigma ~ normal(0.5, 0.5);

    // Likelihood
    for (i in 1:N) {
      target += n[i] * primarycensored_lpmf(
        y[i] | 1, {mu, sigma},
        pwindow[i], y_upper[i], D[i],
        1, primary_params
      );
    }
  }",
  con = file.path(tempdir(), "primarycensored_lognormal.stan")
)

primarycensored_model <- cmdstan_model(
  file.path(tempdir(), "primarycensored_lognormal.stan"),
  include_paths = pcd_stan_path()
)

primarycensored_fit <- primarycensored_model$sample(
  data = list(
    y = delay_counts$observed_delay,
    y_upper = delay_counts$observed_delay_upper,
    n = delay_counts$n,
    pwindow = delay_counts$pwindow,
    D = delay_counts$obs_time,
    N = nrow(delay_counts)
  ),
  chains = 4,
  parallel_chains = 4,
  refresh = ifelse(interactive(), 50, 0),
  show_messages = interactive()
)

primarycensored_fit

pcd_model <- pcd_cmdstan_model(cpp_options = list(stan_threads = TRUE))

pcd_data <- pcd_as_stan_data(
  delay_counts,
  delay = "observed_delay",
  delay_upper = "observed_delay_upper",
  relative_obs_time = "obs_time",
  dist_id = 1, # Lognormal distribution
  primary_id = 1, # Uniform primary distribution
  param_bounds = list(lower = c(-Inf, 0), upper = c(Inf, Inf)),
  primary_param_bounds = list(lower = numeric(0), upper = numeric(0)),
  priors = list(location = c(1, 0.5), scale = c(1, 0.5)),
  primary_priors = list(location = numeric(0), scale = numeric(0)),
  use_reduce_sum = TRUE # use within chain parallelisation
)

pcd_fit <- pcd_model$sample(
  data = pcd_data,
  chains = 4,
  parallel_chains = 2, # Run 2 chains in parallel
  threads_per_chain = 2, # Use 2 cores per chain
  refresh = ifelse(interactive(), 50, 0),
  show_messages = interactive()
)

pcd_fit
