# Tutorial

## Learning python as an R user

Linking to vignette or quick-start resources where possible:

* [Python Rgonomics](https://www.emilyriederer.com/post/py-rgo/); [`polars`'s Rgonomic Patterns](https://www.emilyriederer.com/post/py-rgo-polars/)
* The PyData ecosystem, including: [`Numpy`](https://numpy.org/devdocs/user/quickstart.html), `Scipy`, [`Pandas`](https://pandas.pydata.org/docs/user_guide/10min.html), `Scikit-Learn`, `NLTK`, `PyMC`, `Numba`, and `Blaze`
* Plotting in python is limited, stick to R
  * `Seaborn` and `altair` are okay
  * Could learn [Observable `plot`](https://observablehq.com/)
* `bambi` as a `brms` interface; `PyMC`, `NumPyro` or `cmdstanpy` for writing Bayesian models; `Scikit-Learn` for ML; `Jax` or `PyTorch` over `Tensorflow` for NNs
* Should also start managing R packages, can do both python [and R](https://astrobiomike.github.io/R/managing-r-and-rstudio-with-conda) using `conda`
* `hatch` for packaging, see [comparison](https://alpopkes.com/posts/python/packaging_tools/); [`pixi`](https://github.com/prefix-dev/pixi) may be allow for more cross-language management
