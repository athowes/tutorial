# https://www.tidymodels.org/start/

install.packages("tidymodels")
install.packages("broom.mixed")
install.packages("dotwhisker")

library(tidymodels)
library(readr)
library(broom.mixed)
library(dotwhisker)

urchins <- readr::read_csv("https://tidymodels.org/start/models/urchins.csv") |>
  setNames(c("food_regime", "initial_volume", "width")) |>
  mutate(food_regime = factor(food_regime, levels = c("Initial", "Low", "High")))

ggplot(urchins, aes(x = initial_volume, y = width, col = food_regime)) +
  geom_point() +
  theme_minimal() +
  geom_smooth(method = lm, se = FALSE) +
  scale_color_viridis_d(option = "plasma", end = 0.8)

?parsnip::linear_reg

# This is nice, but as a statistician if I were to fit a model I'd probably want to have
# more close control of what is going on, so I'm unsure how useful packages like this are
lm_fit <- linear_reg() |>
  fit(width ~ initial_volume * food_regime, data = urchins)

tidy(lm_fit)

tidy(lm_fit) %>% 
  dwplot(dot_args = list(size = 2, color = "black"),
         whisker_args = list(color = "black"),
         vline = geom_vline(xintercept = 0, colour = "grey50", linetype = 2))

new_points <- expand.grid(initial_volume = 20, food_regime = c("Initial", "Low", "High"))
