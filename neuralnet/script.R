# https://github.com/elizavetasemenova/nn_in_R

library(ggplot2)
library(neuralnet)

set.seed(123)
n <- 1000
x1 <- runif(n, min = -1, max = 1)
x2 <- runif(n, min = -1, max = 1)
y <- ifelse((x1 * x2) > 0, 1, 0)  # binary classification task

data <- data.frame(x1, x2, y)

ggplot(data, aes(x = x1, y = x2, col = as.factor(y))) +
  geom_point()

# Split data into training and testing sets
train_indices <- sample(1:n, 0.7 * n)
train_data <- data[train_indices, ]
test_data <- data[-train_indices, ]

# Define the neural network architecture
# 2 input nodes (x1 and x2)
# 2 nodes in the hidden layer
# 1 output node
# Sigmoid as the activation function for both the hidden and output layers
nn <- neuralnet(y ~ x1 + x2, data = train_data, hidden = 2, act.fct = "logistic")

# Predict on test data
pred <- predict(nn, test_data)

# Convert predicted probabilities to binary predictions
class_pred <- ifelse(pred > 0.5, 1, 0)

# Calculate accuracy
accuracy <- mean(class_pred == test_data$y)
cat("Accuracy:", accuracy, "\n")

pred_full <- predict(nn, data)
class_pred_full <- ifelse(pred_full > 0.5, 1, 0)
