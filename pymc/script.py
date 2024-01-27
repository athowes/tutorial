import arviz as az
import matplotlib.pyplot as plt
import numpy as np
import pymc as pm

RANDOM_SEED = 8927
np.random.seed(RANDOM_SEED)
az.style.use("arviz-darkgrid")

# True parameter values
alpha, sigma = 1, 1
beta = [1, 2.5]

# Size of dataset
size = 100

# Predictor variable
X1 = np.random.randn(size)
X2 = np.random.randn(size) * 0.2

# Simulate outcome variable
Y = alpha + beta[0] * X1 + beta[1] * X2 + np.random.randn(size) * sigma

fig, axes = plt.subplots(1, 2, sharex = True, figsize=(10, 4))
axes[0].scatter(X1, Y, alpha = 0.6)
axes[1].scatter(X2, Y, alpha = 0.6)
axes[0].set_ylabel("Y")
axes[0].set_xlabel("X1")
axes[1].set_xlabel("X2");

print(f"Running on PyMC3 v{pm.__version__}")

basic_model = pm.Model()

with basic_model:

    # Priors for unknown model parameters
    alpha = pm.Normal("alpha", mu = 0, sigma = 10)
    beta = pm.Normal("beta", mu = 0, sigma = 10, shape = 2)
    sigma = pm.HalfNormal("sigma", sigma = 1)

    # Expected value of outcome
    mu = alpha + beta[0] * X1 + beta[1] * X2

    # Likelihood (sampling distribution) of observations
    Y_obs = pm.Normal("Y_obs", mu = mu, sigma = sigma, observed = Y)
    
with basic_model:
    # Draw 1000 posterior samples
    idata = pm.sample()
    
idata
