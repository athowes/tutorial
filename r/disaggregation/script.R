library(SpatialEpi)
library(dplyr)
library(sp)
library(raster)
library(disaggregation)
library(rgeos)

map <- NYleukemia$spatial.polygon
df <- NYleukemia$data
polygon_data <- SpatialPolygonsDataFrame(map, df)

extent_in_km <- 111 * (polygon_data@bbox[, 2] - polygon_data@bbox[, 1])
n_pixels_x <- floor(extent_in_km[[1]])
n_pixels_y <- floor(extent_in_km[[2]])

r <- raster::raster(ncol = n_pixels_x, nrow = n_pixels_y)
r <- raster::setExtent(r, raster::extent(polygon_data))
r[] <- sapply(1:raster::ncell(r), function(x) rnorm(1, ifelse(x %% n_pixels_x != 0, x %% n_pixels_x, n_pixels_x), 3))

r2 <- raster::raster(ncol = n_pixels_x, nrow = n_pixels_y)
r2 <- raster::setExtent(r2, raster::extent(polygon_data))
r2[] <- sapply(1:raster::ncell(r), function(x) rnorm(1, ceiling(x / n_pixels_y), 3))

cov_stack <- raster::stack(r, r2)
cov_stack <- raster::scale(cov_stack)

extracted <- raster::extract(r, polygon_data)
n_cells <- sapply(extracted, length)
polygon_data@data$pop_per_cell <- polygon_data@data$population / n_cells

# Assuming that population distribution is uniform within area
pop_raster <- rasterize(polygon_data, cov_stack, field = "pop_per_cell")
polygon_data <- rgeos::gBuffer(polygon_data, byid = TRUE, width = 0)
# TODO: rgeos not available for this R version

plot(cov_stack)
plot(pop_raster)

data_for_model <- prepare_data(
  polygon_data,
  cov_stack,
  pop_raster,
  response_var = 'cases',
  id_var = 'censustract.FIPS',
  mesh.args = list(cut = 0.01,
                   offset = c(0.1, 0.5),
                   max.edge = c(0.1, 0.2),
                   resolution = 250),
  na.action = TRUE,
  ncores = 1
)

plot(data_for_model)

model_result <- disag_model(
  data_for_model,
  iterations = 1000,
  family = 'poisson',
  link = 'log',
  priors = list(
    priormean_intercept = 0,
    priorsd_intercept = 2,
    priormean_slope = 0.0,
    priorsd_slope = 0.4,
    prior_rho_min = 3,
    prior_rho_prob = 0.01,
    prior_sigma_max = 1,
    prior_sigma_prob = 0.01,
    prior_iideffect_sd_max = 0.05,
    prior_iideffect_sd_prob = 0.01
  )
)

plot(model_result)

model_result$opt
model_result$sd_out$par.random

prediction <- predict(model_result)
plot(prediction)

report <- model_result$obj$report()
report$reportprediction_rate
