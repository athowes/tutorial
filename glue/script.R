install.packages("glue")
library(glue)
library(dplyr)

# Saw this package, and thought perhaps time to say goodbye to paste0?
# https://glue.tidyverse.org/

name <- "Adam"
glue("My name is {name}")

stringr::str_glue("My name is {name}")

glue("My name is {name}, and I'm {age} years old", age = 27)

head(mtcars) |>
  glue_data("{rownames(.)} has {hp} hp")

head(iris) |>
  mutate(description = glue("This {Species} has petal length of {Petal.Length}"))
