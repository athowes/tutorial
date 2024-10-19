#' Note: initially ran into problems here because I was using the x86_64 version of R
#' I installed the aarch64 version following this thread https://community.rstudio.com/t/error-when-using-conda-environment-with-reticulate-incompatible-architecture-have-arm64-need-x86-64/179190/2
#' https://support.posit.co/hc/en-us/articles/360023654474-Installing-and-Configuring-Python-with-RStudio

install.packages("reticulate")
library(reticulate)
reticulate::py_config()
reticulate::py_list_packages()
sessionInfo()
