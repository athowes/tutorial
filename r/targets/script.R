install.packages("targets")
library(targets)

# https://books.ropensci.org/targets/

# Make-like pipeline tool (e.g. GNU Make)
# Dependency graph for the whole workflow: skip steps which haven't changed

# targets is R specific
# Nudges users works function-oriented programming style that suits R

# targets is drake's long-term successor