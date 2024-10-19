# Following https://rstudio.github.io/renv/articles/renv.html

# Helps you create reproducible environments for your R projects
# library: directory containing installed packages
.libPaths()
lapply(.libPaths(), list.files)

# repository: a source of packages
getOption("repos")

# Get started
renv::init()

# Uses a cache, see vignette("package-install")
renv::snapshot()
