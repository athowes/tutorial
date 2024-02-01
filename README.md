# Tutorial

## Learning python as an R user

Linking to vignette or quick-start resources where possible:

* [Python Rgonomics](https://www.emilyriederer.com/post/py-rgo/); [`polars`'s Rgonomic Patterns](https://www.emilyriederer.com/post/py-rgo-polars/)
* The PyData ecosystem, including: [`Numpy`](https://numpy.org/devdocs/user/quickstart.html), `Scipy`, [`Pandas`](https://pandas.pydata.org/docs/user_guide/10min.html), `Scikit-Learn`, `NLTK`, [`PyMC`](https://www.pymc.io/projects/docs/en/stable/learn/core_notebooks/pymc_overview.html), `Numba`, and `Blaze`
* Plotting in python is limited, stick to R
  * `Seaborn` and `altair` are okay
  * Could learn [Observable `plot`](https://observablehq.com/)
* `bambi` as a `brms` interface; `PyMC`, `NumPyro` or `cmdstanpy` for writing Bayesian models; `Scikit-Learn` for ML; `Jax` or `PyTorch` over `Tensorflow` for NNs
* Should also start managing R packages, can do both python [and R](https://astrobiomike.github.io/R/managing-r-and-rstudio-with-conda) using `conda`
* `hatch` for packaging, see [comparison](https://alpopkes.com/posts/python/packaging_tools/); [`pixi`](https://github.com/prefix-dev/pixi) may be allow for more cross-language management

## Package management

To install a new package (e.g. `pymc3`) use:

```
source env/bin/activate
pip install pymc3
```

## Questions I have

* What is [BLAS](https://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms)? Would be nice to understand what these subroutines are

## Topics to learn more about

* Advanced topics in Stan (particularly related to approaches to improve performance)