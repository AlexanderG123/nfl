#### Preamble ####
# Purpose: Predict Patrick Mahomes' lifetime career stats for 200 additional games
# Author: Alexander Guarasci
# Date: November 20, 2024
# Contact: alexander.guarasci@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `arrow` packages must be installed.

# Load necessary libraries
library(dplyr)
library(arrow)
library(caret)  # For the createDataPartition function to split data

# Load the dataset
file_path <- "~/nfl/data/analysis_data/game_stats/merged_player_game.parquet"
player_data <- read_parquet(file_path)

# Filter data for Tom Brady and Patrick Mahomes
brady_data <- player_data %>% filter(player_name == "T.Brady")
mahomes_data <- player_data %>% filter(player_name == "P.Mahomes")

# Select relevant numeric columns for regression
numeric_features <- c(
  "completions", "attempts", "passing_yards", "passing_tds", 
  "interceptions", "carries", "rushing_yards", "rushing_tds"
)

# Ensure no missing values in selected columns for Tom Brady
brady_data_clean <- brady_data %>%
  select(all_of(numeric_features)) %>%
  na.omit()

# Set seed for reproducibility
set.seed(8)

# Create a 80/20 train-test split
train_index <- createDataPartition(brady_data_clean$completions, p = 0.80, list = FALSE)
train_data <- brady_data_clean[train_index, ]
test_data <- brady_data_clean[-train_index, ]

# Create the linear regression model using Brady's training data
reg_model <- lm(
  cbind(
    completions, attempts, passing_yards, passing_tds, interceptions, 
    carries, rushing_yards, rushing_tds
  ) ~ ., 
  data = train_data
)

# Use the trained model to predict on Brady's test data
predicted_brady_stats <- predict(
  reg_model, newdata = test_data
)

# Convert the predictions into a data frame
predicted_df <- as.data.frame(predicted_brady_stats)

# Calculate RMSE for each variable in the test set
rmse_values <- sapply(1:ncol(predicted_df), function(i) {
  sqrt(mean((test_data[[i]] - predicted_df[[i]])^2))
})

# Print RMSE values for each variable
print("RMSE for each variable in the test set:")
print(rmse_values)

# Prepare Mahomes' per-game averages
mahomes_per_game <- mahomes_data %>%
  select(all_of(numeric_features)) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

# Predict Mahomes' stats for the next 200 games using the model
predicted_per_game_stats <- predict(
  reg_model, newdata = mahomes_per_game
)

# Scale the predictions to 200 games
predicted_200_games <- as.data.frame(predicted_per_game_stats) %>%
  mutate(across(everything(), ~ . * 200))

# Calculate Mahomes' lifetime totals (add to current stats)
current_totals <- mahomes_data %>%
  summarise(across(all_of(numeric_features), sum, na.rm = TRUE))

lifetime_totals <- current_totals + predicted_200_games

# Add a summary row with lifetime totals
summary_row <- lifetime_totals %>%
  mutate(player_name = "P.Mahomes",
         games_played = nrow(mahomes_data) + 200)

# Save predictions to a file
output_path <- "~/nfl/data/model_data/mahomes_lifetime_predictions.csv"
write.csv(summary_row, output_path, row.names = FALSE)

# Confirm the script's output
message("Patrick Mahomes lifetime stats saved to: ", output_path)