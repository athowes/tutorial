library(epidemia)

# https://imperialcollegelondon.github.io/epidemia/articles/flu.html

library(lubridate)
library(rstanarm)
library(ggplot2)

options(mc.cores = parallel::detectCores())

library(EpiEstim)
data("Flu1918")
print(Flu1918)

date <- as.Date("1918-01-01") + seq(0, along.with = c(NA, Flu1918$incidence))
data <- data.frame(city = "Baltimore", cases = c(NA, Flu1918$incidence), date = date)

data |>
  ggplot(aes(x = date, y = cases)) +
  geom_point() +
  labs(x = "Date", y = "New cases") +
  geom_smooth(method = mgcv::gam, formula = y ~ s(x), col = "deepskyblue") +
  theme_minimal()

# ERROR: can't seem to install epidemia from either the GitHub development version, or the CRAN version
# Guess I'm stuck here for a while.. may try to fix

rt <- epidemia::epirt(formula = R(city, date) ~ 1 + rw(prior_scale = 0.01), prior_intercept = normal(log(2), 0.2), link = "log")
