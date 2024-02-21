# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html

library(data.table)

flights <- fread("https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")
head(flights)

# An enhanced version of data.frame

dt <- data.table(
  id = c("b", "b", "b", "a", "a", "c"),
  a = 1:6,
  b = 7:12,
  c = 13:18
)

flights[origin == "JFK" & month == 6L]
flights[1:2]
flights[order(origin)]
flights[order(origin, -dest)]
flights[, arr_delay]
flights[, list(arr_delay)]
flights[, .(arr_delay, dep_delay)]
flights[, list(arr_delay, dep_delay)]
flights[, .(delay_arr = arr_delay, delay_dep = dep_delay)]
flights[, sum( (arr_delay + dep_delay) < 0)]
flights[origin == "JFK" & month == 6L, .(m_arr = mean(arr_delay), m_dep = mean(dep_delay))]
flights[origin == "JFK" & month == 6L, length(year)]
flights[origin == "JFK" & month == 6L, .(N = length(year))]
flights[origin == "JFK" & month == 6L, .(N = length(year))]
flights[origin == "JFK" & month == 6L, .N]
flights[, c("arr_delay", "dep_delay")]
select_cols = c("arr_delay", "dep_delay")
flights[ , ..select_cols]
flights[ , select_cols, with = FALSE]

df = data.frame(
  x = c(1, 1, 1, 2, 2, 3, 3, 3),
  y = 1:8
)

df[df$x > 1, ]
df[with(df, x > 1), ]

flights[, !c("arr_delay", "dep_delay")]
flights[, -c("arr_delay", "dep_delay")]
