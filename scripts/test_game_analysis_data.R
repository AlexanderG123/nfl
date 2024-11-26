#### Preamble ####
# Purpose: Tests analysis NFL game data for Tom Brady and Patrick Mahomes
# Author: Alexander Guarasci
# Date: 26 November 2024
# Contact: alexander.guarasci@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `dplyr`, `arrow` and 'testthat' packages must be installed, and clean_data.R must be run

library(testthat)
library(arrow)
library(dplyr)

# Load the data
load_data <- function() {
  read_parquet("~/nfl/data/analysis_data/game_stats/merged_player_game.parquet")
}

# Test if weeks are between 1 and 22
test_that("Weeks are between 1 and 22", {
  df <- load_data()
  invalid_weeks <- df %>% filter(week < 1 | week > 22)
  expect_true(nrow(invalid_weeks) == 0, "Invalid weeks found")
})

# Test player names are either Tom Brady or Patrick Mahomes
test_that("Player names are Tom Brady or Patrick Mahomes", {
  df <- load_data()
  invalid_players <- df %>% filter(!(player_name %in% c("T.Brady", "P.Mahomes")))
  expect_true(nrow(invalid_players) == 0, "Invalid player names found")
})




# Test if seasons are between 2000 and 2024
test_that("Seasons are between 2000 and 2024", {
  df <- load_data()
  invalid_seasons <- df %>% filter(season < 2000 | season > 2024)
  
  # Print invalid seasons for debugging
  print(invalid_seasons$season)
  
  # Check if all seasons are valid
  expect_true(nrow(invalid_seasons) == 0, "Invalid seasons found")
})

test_that("Passing touchdowns are positive integers", {
  df <- load_data()
  invalid_passing_tds <- df %>% filter(passing_tds < 0 | !is.integer(passing_tds))
  
  # Print invalid passing touchdowns for debugging
  print(invalid_passing_tds$passing_tds)
  
  # Check if all passing touchdowns are positive integers
  expect_true(nrow(invalid_passing_tds) == 0, "Invalid passing touchdowns found")
})
test_that("Interceptions are non-negative integers", {
  df <- load_data()
  
  # Ensure interceptions are non-negative integers
  invalid_interceptions <- df %>% filter(interceptions < 0 | interceptions != floor(interceptions))
  
  # Check that there are no invalid interceptions
  expect_true(nrow(invalid_interceptions) == 0, "Invalid interceptions found")
})