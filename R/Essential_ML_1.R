## caret = classification and regression tree

library(caret)
library(tidyverse)

# train test split
# 1. split data
# 2. train
# 3. score
# 4. evaluate

glimpse(mtcars)

# split data 80% : 20%
train_test_split <- function(data, trainRatio=0.7){
  set.seed(42)
  n <- nrow(data)
  id <- sample(1:n, size=trainRatio*n)
  train_data <- data[id, ]
  test_data <- data[-id, ]
  return( list(train=train_data, test=test_data))
}

splitData <- train_test_split(mtcars, 0.7)
train_data <- splitData$train
test_data <- splitData$test

# train model
model <- lm(mpg ~ hp + wt + am, data = train_data)

# score model
mpg_pred <- predict(model, newdata = test_data)

# evaluate model
# MAE, MSE, RMSE

mae_metric <- function(actual, prediction){
  # mean absolute error
  abs_error <- abs(actual - prediction)
  mean(abs_error)
}
# mae_metric(test_data$mpg, mpg_pred) console

mse_metric <- function(actual, prediction){
  # mean squared error
  sq_error <- (actual - prediction)**2
  mean(sq_error)
}

rmse_metric <- function(actual, prediction){
  # root mean squared error
  sq_error <- (actual - prediction)**2
  sqrt(mean(sq_error)) # back to normal unit
}

actual = test_data$mpg
prediction = mpg_pred
mae_metric(actual, prediction)

# การบ้าน build model Regression house-price-india

## CARET 
## Supervised Learning = Prediction

library(caret)

# 1. split data
splitData <- train_test_split(mtcars, 0.7)
train_data <- splitData$train
test_data <- splitData$test

# 2. train
set.seed(42)

ctrl <- train
model <- train(mpg ~ hp + wt +am, 
               data = train_data,
               method = "lm") # algolitm
# 3. score
p <-  predict(model, newdata = test_data)

# 4. evaluate
rmse_metric(test_data$mpg, p)

# 5. save model
saveRDS(model, "linear_regression_v1.RDS")


















