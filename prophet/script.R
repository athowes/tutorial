# install.packages("prophet")

library(prophet)
library(ggplot2)

df <- read.csv('https://raw.githubusercontent.com/facebook/prophet/main/examples/example_wp_log_peyton_manning.csv')

ggplot(df, aes(x = as.Date(ds), y = y)) +
  geom_point() +
  labs(x = "Date", y = "")

m <- prophet::prophet(df)

future <- make_future_dataframe(m, periods = 365)
forecast <- predict(m, future)

ggplot() +
  geom_ribbon(data = forecast, aes(x = as.Date(ds), ymin = yhat_lower, y = yhat, ymax = yhat_upper), alpha = 0.3) +
  geom_point(data = df, aes(x = as.Date(ds), y = y))

prophet::prophet_plot_components(m, forecast)
