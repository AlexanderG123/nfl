#### Preamble ####
# Purpose: Downloads NFL data for Tom Brady and Patrick Mahomes
# Author: Alexander Guarasci
# Date: 26 November 2024
# Contact: alexander.guarasci@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `nflverse` and `arrow` packages must be installed

library(nflverse)
library(arrow)


# Download player statistics for all available seasons
## must be broken up into decades so all data is collected
## 2000's
player_stats_2000 <- load_player_stats(seasons = 2000:2009)
write_parquet(player_stats_2000, "data/raw_data/game_stats/player_game_00s.parquet") # nolint: line_length_linter.
## 2010's
player_stats_2010 <- load_player_stats(seasons = 2010:2019)
write_parquet(player_stats_2010, "data/raw_data/game_stats/player_game_10s.parquet") # nolint: line_length_linter.
## 2020-2023
player_stats_2020 <- load_player_stats(seasons = 2020:2023)
write_parquet(player_stats_2020, "data/raw_data/game_stats/player_game_20s.parquet") # nolint: line_length_linter.

## Also downloading player game data for players in the current season
player_stats_2024 <- load_player_stats(seasons = 2024)
write_parquet(player_stats_2024, "data/raw_data/game_stats/player_game_current.parquet") # nolint: line_length_linter.

# Download team stats for each season

# Download QBR stats for 2006-2023
tryCatch({
  qbr_to_2023 <- load_espn_qbr(seasons = 2006:2023)  # Adjusted function call
  write_parquet(qbr_to_2023, "data/raw_data/advanced_stats/qbr_06_23.parquet")
  message("Successfully saved QBR stats for 2006-2023.")
}, error = function(e) {
  message("Error downloading QBR stats: ", e$message)
})

# Download QBR stats for 2024
tryCatch({
  qbr_2024 <- load_espn_qbr(seasons = 2024)
  write_parquet(qbr_2024, "data/raw_data/advanced_stats/qbr_2024.parquet")
  message("Successfully saved QBR stats for 2024.")
}, error = function(e) {
  message("Error downloading QBR stats for 2024: ", e$message)
})

nextgen_16_24 <- load_nextgen_stats(seasons = 2016:2024)
write_parquet(nextgen_16_24, "data/raw_data/advanced_stats/next_gen.parquet")



