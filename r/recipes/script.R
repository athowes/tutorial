install.packages("recipes")
install.packages("rsample")
install.packages("modeldata")

# Following https://recipes.tidymodels.org/articles/recipes.html

# Variables: the data columns used in the model
# Roles: how they are used in the model
# Terms: columns of the design matrix

library(recipes)
library(rsample)
library(modeldata)

data("credit_data")

head(credit_data)

set.seed(55)
train_test_split <- initial_split(credit_data)
train_test_split

credit_train <- training(train_test_split)
credit_test <- testing(train_test_split)

vapply(credit_train, function(x) mean(!is.na(x)), numeric(1))

rec_obj <- recipe(Status ~ ., data = credit_train)

# There are a few data imputation methods included in the package
grep("impute_", ls("package:recipes"), value = TRUE)

# Imputation with KNN
imputed <- rec_obj |>
  step_impute_knn(all_predictors())

imputed

# Make all the categorical predictors dummy
ind_vars <- imputed |>
  step_dummy(all_nominal_predictors())

ind_vars

# Standardise all the numeric predictors
standardised <- ind_vars |>
  step_center(all_numeric_predictors()) |>
  step_scale(all_numeric_predictors())

standardised

trained_rec <- prep(standardised, training = credit_train)

train_data <- bake(trained_rec, new_data = credit_train)
test_data <- bake(trained_rec, new_data = credit_test)

train_data
test_data

# By default bake includes all variables, but you can get just a subset if you would like
# Though it seems like why not just bake then select after?

bake(trained_rec, new_data = credit_train, all_predictors())

# There are also checks included in the package (good for defensive workflow!)
trained_rec <- trained_rec |>
  check_missing(contains("Marital"))
