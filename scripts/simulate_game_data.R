#### Preamble ####
# Purpose: Simulates and saves a dataset containing NFL game data for Tom Brady and Patrick Mahomes
# Author: Alexander Guarasci
# Date: 3 December, 2024
# Contact: alexander.guarasci@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `dplyr` and `arrow` packages must be installed.

# Load necessary libraries
library(dplyr)
library(arrow)

# Set a random seed for reproducibility
set.seed(123)

# Number of rows to simulate
n <- 500  # Total data points

# Simulate data for Tom Brady and Patrick Mahomes
simulated_data <- tibble(
  player_name = sample(c("T. Brady", "P. Mahomes"), n, replace = TRUE),
  player_display_name = ifelse(player_name == "T. Brady", "Tom Brady", "Patrick Mahomes"),
  position = "QB",  # Position is fixed as QB
  recent_team = ifelse(player_name == "T. Brady", "Patriots", "Chiefs"),
  season = sample(2000:2024, n, replace = TRUE),
  week = sample(1:22, n, replace = TRUE),  # Weeks are between 1 and 22
  season_type = sample(c("Regular", "Playoffs"), n, replace = TRUE),
  opponent_team = sample(c("NE", "KC", "BUF", "MIA", "DEN", "LAC", "LV"), n, replace = TRUE),
  completions = sample(10:50, n, replace = TRUE),
  attempts = sample(20:60, n, replace = TRUE),
  passing_yards = sample(100:500, n, replace = TRUE),
  passing_tds = sample(0:5, n, replace = TRUE),
  interceptions = sample(0:3, n, replace = TRUE),
  sack_fumbles = sample(0:2, n, replace = TRUE),
  sack_fumbles_lost = sample(0:1, n, replace = TRUE),
  passing_air_yards = sample(50:400, n, replace = TRUE),
  passing_first_downs = sample(5:30, n, replace = TRUE),
  passing_2pt_conversions = sample(0:1, n, replace = TRUE),
  carries = sample(0:10, n, replace = TRUE),
  rushing_yards = sample(-5:100, n, replace = TRUE),
  rushing_tds = sample(0:3, n, replace = TRUE),
  rushing_fumbles = sample(0:2, n, replace = TRUE),
  rushing_fumbles_lost = sample(0:1, n, replace = TRUE),
  rushing_first_downs = sample(0:5, n, replace = TRUE)
)

# Save the simulated data to a Parquet file
write_parquet(simulated_data, "~/nfl/data/simulated_data/simulated_game_data.parquet")

# Confirm the data was written
message("Simulated data saved to 'simulated_game_data.parquet'")
