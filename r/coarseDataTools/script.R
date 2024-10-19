install.packages("coarseDataTools")
library(coarseDataTools)

data("simulated.outbreak.deaths")

library(ggplot2)
library(tidyverse)

df <- simulated.outbreak.deaths |>
  data.frame() |>
  select(time, group = grp, r = R, d = D, n = N)

df |>
  pivot_longer(cols = c("r", "d"), names_to = "compartment", values_to = "count") |>
  ggplot(aes(x = time, y = count, group = group, col = as.factor(group))) +
  geom_line() +
  facet_wrap(~ compartment, scales = "free") +
  theme_minimal()

min_cases <- 10

n1 <- df |> filter(group == 1) |> select(n)
n2 <- df |> filter(group == 2) |> select(n)

t1 <- min(which(n1 > min_cases & n2 > min_cases))
t2 <- max(which(n1 > min_cases & n2 > min_cases))

new_times <- seq_along(t1:t2)

simulated.outbreak.deaths <- cbind(simulated.outbreak.deaths, new.times = NA)
simulated.outbreak.deaths[c(t1:t2, t1:t2 + 60, "new.times"] <- rep(new_times, 2)

# log(E(D_{tj})) = log(N_{tj}) + beta_0 + alpha_t * X_t + gamma_j * Y_j

# X_t are times
# Y_j are groups
# gamma_j is the log relative case fataility ratio

# Use the EM algorithm

# Probability of dying each day after disease onset (are these initialisation?)
nu <- c(0, 0.3, 0.4, 0.3)

# Looks like assuming no temporal changes in death rate (as initialisation parameters)
alpha <- rep(0, 22)

cfr_estimates <- coarseDataTools::EMforCFR(
  assumed.nu = nu,
  alpha.start.values = alpha,
  full.data = simulated.outbreak.deaths,
  verb = FALSE,
  SEM.var = TRUE,
  max.iter = 100,
  tol = 1e-5
)
