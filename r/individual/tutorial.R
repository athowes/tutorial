#' Following https://mrc-ide.github.io/individual/articles/Tutorial.html

devtools::install_github("mrc-ide/individual")
library(individual)
library(ggplot2)

N <- 1000 # Population size
I0 <- 5 # Initial number of infected
S0 <- N - I0 # Initial number of susceptibles
dt <- 0.1 # Time step
tmax <- 100 # Maximum time
steps <- tmax / dt # Number of time steps
gamma <- 0.1 # Recovery rate
R0 <- 2.5 # Reproduction number
beta <- R0 * gamma # Effective contact rate

health_states <- c("S", "I", "R")
health_states_t0 <- rep("S", N)
health_states_t0[sample.int(n = N, size = I0)] <- "I" # Random indices for infected

health <- individual::CategoricalVariable$new(categories = health_states, initial_values = health_states_t0)

#' A function that takes current time and changes things for the next time
#' Here we start with the infection process

infection_process <- function(t) {
  I <- health$get_size_of("I")
  foi <- beta * I / N
  S <- health$get_index_of("S")
  S$sample(rate = pexp(q = foi * dt))
  health$queue_update(value = "I", index = S)
}

recovery_event <- TargetedEvent$new(population_size = N)

recovery_event$add_listener(function(t, target) {
  health$queue_update("R", target)
})

recovery_process <- function(t) {
  I <- health$get_index_of("I")
  already_scheduled <- recovery_event$get_scheduled()
  I$and(already_scheduled$not(inplace = TRUE))
  rec_times <- rgeom(n = I$size(), prob = pexp(q = gamma * dt)) + 1
  recovery_event$schedule(target = I, delay = rec_times)
}

health_render <- Render$new(timesteps = steps)

health_render_process <- categorical_count_renderer_process(
  renderer = health_render,
  variable = health,
  categories = health_states
)

simulation_loop(
  variables = list(health),
  events = list(recovery_event),
  processes = list(infection_process,recovery_process,health_render_process),
  timesteps = steps
)

states <- health_render$to_dataframe()

states %>%
  tidyr::pivot_longer(
    cols = c("S_count", "I_count", "R_count"),
    names_to = "compartment",
    values_to = "count"
  ) %>%
  ggplot(aes(x = timestep, y = count, col = compartment)) +
    geom_line() + 
    theme_minimal() +
    labs(x = "Time", y = "Count")

ggsave("individual/sir.png", h = 3, w = 6.25)
