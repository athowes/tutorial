install.packages("ergm")
library(ergm)

set.seed(0)

# https://cran.r-project.org/web/packages/ergm/vignettes/ergm.pdf
# P(Y = y) = exp(theta * g(y)) / k(theta)

data(package = "ergm")
data(florentine)

plot(flomarriage, label = network.vertex.names(flomarriage))
plot(flomarriage, vertex.cex = flomarriage %v% "wealth" / 25)
