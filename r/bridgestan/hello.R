# Before running this:

system("make bernoulli_model.so")

devtools::install_github("https://github.com/roualdes/bridgestan", subdir = "R")

library(bridgestan)

rstan::stan_model("bernoulli_model.stan")

model <- StanModel$new("bernoulli_model.so", "bernoulli_data.json", 1234, 0)

print(paste0("This model's name is ", model$name(), "."))
print(paste0("This model has ", model$param_num(), " parameters."))

x <- runif(model$param_unc_num())
q <- log(x / (1 - x))

res <- model$log_density_gradient(q, jacobian = FALSE)

print(paste0("log_density and gradient of Bernoulli model: ", res$val, ", ", res$gradient))
