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

# Load the dataset
file_path <- "~/nfl/data/analysis_data/game_stats/merged_player_game.parquet"
player_data <- read_parquet(file_path)

# Filter data for Tom Brady and Patrick Mahomes
brady_data <- player_data %>% filter(player_name == "T.Brady")
mahomes_data <- player_data %>% filter(player_name == "P.Mahomes")

# Select numeric columns for regression
numeric_features <- c(
  "completions", "attempts", "passing_yards", "passing_tds",
  "interceptions", "sack_fumbles", "sack_fumbles_lost",
  "passing_air_yards", "passing_first_downs", "passing_2pt_conversions",
  "carries", "rushing_yards", "rushing_tds", "rushing_fumbles",
  "rushing_fumbles_lost", "rushing_first_downs"
)

# Ensure no missing values in selected columns for Tom Brady
brady_data_clean <- brady_data %>%
  select(all_of(numeric_features)) %>%
  na.omit()

# Create the linear regression model
reg_model <- lm(
  cbind(
    completions, attempts, passing_yards, passing_tds, interceptions,
    sack_fumbles, sack_fumbles_lost, passing_air_yards, passing_first_downs,
    passing_2pt_conversions, carries, rushing_yards, rushing_tds,
    rushing_fumbles, rushing_fumbles_lost, rushing_first_downs
  ) ~ ., 
  data = brady_data_clean
)

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
output_path <- "~/nfl/data/analysis_data/mahomes_lifetime_predictions.csv"
write.csv(summary_row, output_path, row.names = FALSE)

# Confirm the script's output
message("Patrick Mahomes lifetime stats saved to: ", output_path)