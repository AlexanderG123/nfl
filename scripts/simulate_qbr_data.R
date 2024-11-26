#### Preamble ####
# Purpose: Simulates and saves a dataset containing select QBR data for Tom Brady and Patrick Mahomes, retaining only specified columns.
# Author: Alexander Guarasci
# Date: 26 November 2024
# Contact: alexander.guarasci@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `dplyr` and `arrow` packages must be installed.

# Load necessary libraries
library(dplyr)
library(arrow)

# Set a random seed for reproducibility
set.seed(123)

# Number of rows to simulate for each player
n_brady <- 23  # From 2000 to 2022 (23 seasons)
n_mahomes <- 8  # From 2017 to 2024 (8 seasons)

# Simulate data for Tom Brady (2000-2022)
brady_data <- tibble(
  season = rep(2000:2022, each = 2),  # Two rows for each season (Regular and Playoffs)
  season_type = rep(c("Regular", "Playoffs"), n_brady),
  game_week = "Season Total",  # All rows will be "Season Total"
  team_abb = "NE",  # Only for New England Patriots (Tom Brady)
  name_short = rep("T. Brady", n_brady * 2),
  rank = round(runif(n_brady * 2, 1, 10), 1),
  qbr_total = round(runif(n_brady * 2, 50, 100), 1),
  qbr_raw = round(runif(n_brady * 2, 60, 100), 1),
  name_last = rep("Brady", n_brady * 2),
  name_display = rep("Tom Brady", n_brady * 2),
  team = rep("Patriots", n_brady * 2),
  qualified = sample(c(TRUE, FALSE), n_brady * 2, replace = TRUE)
)

# Simulate data for Patrick Mahomes (2017-2024)
mahomes_data <- tibble(
  season = rep(2017:2024, each = 2),  # Two rows for each season (Regular and Playoffs)
  season_type = rep(c("Regular", "Playoffs"), n_mahomes),
  game_week = "Season Total",  # All rows will be "Season Total"
  team_abb = "KC",  # Only for Kansas City Chiefs (Patrick Mahomes)
  name_short = rep("P. Mahomes", n_mahomes * 2),
  rank = round(runif(n_mahomes * 2, 1, 10), 1),
  qbr_total = round(runif(n_mahomes * 2, 50, 100), 1),
  qbr_raw = round(runif(n_mahomes * 2, 60, 100), 1),
  name_last = rep("Mahomes", n_mahomes * 2),
  name_display = rep("Patrick Mahomes", n_mahomes * 2),
  team = rep("Chiefs", n_mahomes * 2),
  qualified = sample(c(TRUE, FALSE), n_mahomes * 2, replace = TRUE)
)

# Combine the data for both players
combined_data <- bind_rows(brady_data, mahomes_data)

# Filter only Season Total data (already filtered but ensuring no duplicates)
data_sim_filtered <- combined_data %>%
  filter(game_week == "Season Total") %>%
  select(season, season_type, team_abb, name_short, rank, 
         qbr_total, qbr_raw, name_last, name_display, team, qualified)

# Save the simulated data to a Parquet file
write_parquet(data_sim_filtered, "~/nfl/data/simulated_data/simulated_qbr_data.parquet")

# Confirm the data was written
message("Simulated data for Season Total (Regular and Playoffs) saved to 'simulated_qbr_player_data_season_total.parquet'")
