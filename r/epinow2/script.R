# install.packages("EpiNow2", repos = "https://epiforecasts.r-universe.dev")

library(EpiNow2)
library(ggplot2)

ggplot(example_confirmed, aes(x = date, y = confirm)) +
  geom_point() +
  labs(x = "Date", y = "Cases") +
  geom_smooth(method = mgcv::gam, formula = y ~ s(x), col = "deepskyblue") +
  theme_minimal() 

options(mc.cores = 4)

dist <- dist_spec(mean = 3, sd = 1, distribution = "gamma", max = 10)
plot(dist)

dist <- dist_spec(mean = 3, mean_sd = 2, sd = 1, sd_sd = 0.1, distribution = "gamma", max = 10)
plot(dist) # I feel like this plot should be different to the one above

?plot.dist_spec

generation_time <- dist_spec(mean = 3, mean_sd = 2, sd = 1, sd_sd = 0.1, distribution = "gamma", max = 10)

incubation_period <- dist_spec(
  mean = 1.6, mean_sd = 0.05, sd = 0.5, sd_sd = 0.05,
  distribution = "lognormal", max = 14
)

reporting_delay <- dist_spec(
  mean = 0.5, sd = 0.5, distribution = "lognormal", max = 10
)

delay <- incubation_period + reporting_delay
EpiNow2:::plot.dist_spec(delay)

obs_scale <- list(mean = 0.4, sd = 0.01)
rt_prior <- list(mean =  2, sd = 1)

def <- estimate_infections(
  example_confirmed, 
  generation_time = generation_time_opts(generation_time),
  delays = delay_opts(delay),
  rt = rt_opts(prior = rt_prior)
)

plot(def)
