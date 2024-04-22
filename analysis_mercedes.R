# pRoject by abdul aziz
# Install Libraries
library(tidyverse)
library(ggplot2)
library(caret)
library(randomForest)

# Load Data
df <- read.csv("data_merc.csv")

# Explore Data
head(df)
str(df)
summary(df)

# Check for missing values
colSums(is.na(df))

# Visualization Section
# Average Price by Model
result_avg_price <- df %>%
  group_by(model) %>%
  summarize(count = n(), avg_price = mean(price, na.rm = TRUE)) %>%
  arrange(desc(avg_price))

# Plot Average Price by Model
ggplot(result_avg_price, aes(x = avg_price, y = reorder(model, avg_price))) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  geom_text(aes(label = scales::dollar(avg_price), hjust = -0.5), color = "black") +
  labs(title = "Average Price by Model",
       x = "Average Price",
       y = "Model") +
  theme(axis.text.y = element_text(angle = 0, hjust = 1))

# Number of Cars by Model
result_no_model <- df %>%
  group_by(model) %>%
  summarize(count = n()) %>%
  arrange(desc(count)) %>%
  mutate(percentage = (count / sum(count)) * 100) 

result_no_model %>%
  view()

# Plot Number of Cars by Model
ggplot(result_no_model, aes(x = reorder(model, count), y = count)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  geom_text(aes(label = count, vjust = -0.5), color = "black") +
  labs(title = "Number of Cars by Model",
       x = "Model",
       y = "Number of Cars") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Filter out models with a sample size less than 50
df <- df %>%
  group_by(model) %>%
  filter(n() >= 50)

# Plot Distribution of Prices
ggplot(df, aes(x = price)) +
  geom_histogram(binwidth = 500, fill = "skyblue") +
  labs(title = "Distribution of Prices",
       x = "Price",
       y = "Count")

# Plot Distribution of MPG
ggplot(df, aes(x = mpg)) +
  geom_histogram(binwidth = 10, fill = "skyblue") +
  labs(title = "Distribution of MPG",
       x = "MPG",
       y = "Count")

# Plot Distribution of Engine Size
ggplot(df, aes(x = engineSize)) +
  geom_histogram(binwidth = 0.2, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Engine Size",
       x = "Engine Size",
       y = "Count")

# Plot Correlation between price and mileage
cor_value <- cor(df$price, df$mileage)

ggplot(df, aes(x = mileage, y = price)) +
  geom_point(color = "skyblue") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  geom_text(x = max(df$mileage), y = min(df$price), 
            label = paste("Correlation =", round(cor_value, 2)),
            hjust = 1, vjust = 0) +
  labs(title = "Correlation between Price and Mileage",
       x = "Mileage",
       y = "Price")

# Data Preparation Section
# Convert categorical variables to factors
df <- df %>%
  mutate(across(c(transmission, fuelType), as.factor))

df$model <- as.factor(df$model)

# Remove 0 Engine Size
df <- df %>%
  filter(engineSize != 0)

# Identify and handle outliers for Prices
outliers <- boxplot.stats(df$price)$out
df <- df %>%
  filter(!price %in% outliers)

# Identify and handle outliers for MPG
outliers_mpg <- boxplot.stats(df$mpg)$out
df <- df %>%
  filter(!mpg %in% outliers_mpg)

# Plot Distribution of Prices after removing outliers
ggplot(df, aes(x = price)) +
  geom_histogram(binwidth = 500, fill = "skyblue") +
  labs(title = "Distribution of Prices",
       x = "Price",
       y = "Count")

ggplot(df, aes(x = mpg)) +
  geom_histogram(binwidth = 10, fill = "skyblue") +
  labs(title = "Distribution of MPG",
       x = "MPG",
       y = "Count")

# Final Dataset
glimpse(df)
view(df)

# Modeling Section
# Train-Test Split (80:20)
set.seed(123)
split <- createDataPartition(y = df$price, p = 0.8, list = FALSE)
train_set <- df[split, ]
test_set <- df[-split, ]

# Model Training
# Linear Regression as Baseline Model
lm_model <- lm(price ~ ., data = train_set)
lm_predictions <- predict(lm_model, newdata = test_set)

# Random Forest
rf_model <- randomForest(price ~ ., data = train_set)
rf_predictions <- predict(rf_model, newdata = test_set)

# Model Evaluation
# Calculate RMSE for both models
lm_rmse <- RMSE(lm_predictions, test_set$price)
rf_rmse <- RMSE(rf_predictions, test_set$price)

# Print the evaluation metrics for RMSE
cat("Linear Regression RMSE:", lm_rmse, "\n")
cat("Random Forest RMSE:", rf_rmse, "\n")

# Combine the results for plotting
results_rmse <- data.frame(
  Model = c("Linear Regression", "Random Forest"),
  RMSE = c(lm_rmse, rf_rmse)
)

# Plot the bar chart for RMSE comparison
ggplot(results_rmse, aes(x = Model, y = RMSE, fill = Model)) +
  geom_bar(stat = "identity", color = "black") +
  geom_text(aes(label = round(RMSE, 2)), vjust = -0.5) +
  labs(title = "RMSE Comparison: Linear Regression vs. Random Forest",
       y = "RMSE") +
  theme_minimal()

# Random Forest Model Evaluation
# Calculate RMSE for both training and test sets
rf_predictions_train <- predict(rf_model, newdata = train_set)
rf_rmse_train <- RMSE(rf_predictions_train, train_set$price)
rf_mae_train <- MAE(rf_predictions_train, train_set$price)

rf_predictions_test <- predict(rf_model, newdata = test_set)
rf_rmse_test <- RMSE(rf_predictions_test, test_set$price)
rf_mae_test <- MAE(rf_predictions_test, test_set$price)

# Print the evaluation metrics for Random Forest
cat("Random Forest Training RMSE:", rf_rmse_train, "\n")
cat("Random Forest Training MAE:", rf_mae_train, "\n")
cat("Random Forest Test RMSE:", rf_rmse_test, "\n")
cat("Random Forest Test MAE:", rf_mae_test, "\n")

# Combine the results for plotting
results_rf <- data.frame(
  Set = rep(c("Training", "Test"), each = 2),
  Metric = rep(c("RMSE", "MAE"), times = 2),
  Value = c(rf_rmse_train, rf_mae_train, rf_rmse_test, rf_mae_test)
)

# Plot the bar chart for Random Forest Model Evaluation
ggplot(results_rf, aes(x = Value, y = Set, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = round(Value, 2)), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(title = "Random Forest Model Evaluation: RMSE and MAE",
       x = "Value",
       y = "Set") +
  scale_fill_manual(values = c("skyblue", "orange")) +
  theme_minimal()

# Plot the predictions against actual prices for Random Forest
ggplot() +
  geom_point(aes(x = test_set$price, y = rf_predictions), color = "skyblue") +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(title = "Random Forest: Predictions vs. Actual Prices",
       x = "Actual Price",
       y = "Predicted Price")

# Visualize Feature Importance for Random Forest
varImpPlot(rf_model, main = "Variable Importance")

# Save the Random Forest model
saveRDS(rf_model, "random_forest_model.rds")