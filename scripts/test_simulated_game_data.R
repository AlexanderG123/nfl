# Load necessary libraries
library(dplyr)
library(arrow)
library(testthat)

# Set the file path
file_path <- "~/nfl/data/simulated_data/simulated_game_data.parquet"

# Load the data
data <- read_parquet(file_path)

# Test 1: Check the Number of Rows
test_that("Number of rows is 500", {
  expect_equal(nrow(data), 500)
})

# Test 2: Check the Presence of Key Columns
test_that("All required columns are present", {
  required_columns <- c('player_id', 'player_name', 'season', 'week', 'opponent_team', 'completions', 'attempts', 'passing_yards', 'passing_tds', 'fantasy_points')
  missing_columns <- setdiff(required_columns, colnames(data))
  expect_true(length(missing_columns) == 0, info = paste("Missing columns: ", paste(missing_columns, collapse = ", ")))
})

# Test 3: Verify the Player Names
test_that("Player names are valid", {
  valid_players <- c("Tom Brady", "Patrick Mahomes")
  invalid_players <- setdiff(unique(data$player_name), valid_players)
  expect_true(length(invalid_players) == 0, info = paste("Unexpected player names found: ", paste(invalid_players, collapse = ", ")))
})

# Test 4: Check for Missing Data
test_that("No missing data in the dataset", {
  expect_true(all(!is.na(data)), info = "There are missing values in the dataset.")
})

# Test 5: Check for Valid Fantasy Points
test_that("Fantasy points are non-negative", {
  expect_true(all(data$fantasy_points >= 0, na.rm = TRUE), info = "Fantasy points contain negative values.")
})

# Test 6: Verify Valid Seasons and Weeks
test_that("Season and week values are within valid ranges", {
  expect_true(all(data$season >= 2000 & data$season <= 2024, na.rm = TRUE), info = "Season values are out of range.")
  expect_true(all(data$week >= 1 & data$week <= 17, na.rm = TRUE), info = "Week values are out of range.")
})

# Test 7: Verify Passing Yards and Attempts Consistency
test_that("Passing yards are non-negative when attempts are greater than zero", {
  expect_true(all(!(data$attempts > 0 & data$passing_yards < 0)), info = "Passing yards are negative when attempts are greater than zero.")
})

# Print confirmation if tests pass
message("All tests have passed successfully.")