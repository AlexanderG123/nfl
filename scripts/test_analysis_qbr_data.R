#### Preamble ####
# Purpose: Tests analysis NFL QBR data for Tom Brady and Patrick Mahomes
# Author: Alexander Guarasci
# Date: 1 December, 2024
# Contact: alexander.guarasci@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `dplyr`, `arrow` and 'testthat' packages must be installed, and clean_data.R must be run


# Load necessary libraries
library(dplyr)
library(arrow)
library(testthat)

# Set the file path
file_path <- "~/nfl/data/analysis_data/advanced_stats/merged_qbr.parquet"

# Load the data
data <- read_parquet(file_path)

# Test 1: Check that names are either "Tom Brady" or "Patrick Mahomes"
test_that("Names are either Tom Brady or Patrick Mahomes", {
  valid_names <- c("Tom Brady", "Patrick Mahomes")
  invalid_names <- unique(data$name_display[!data$name_display %in% valid_names])
  expect_true(length(invalid_names) == 0, info = paste("Invalid player names: ", paste(invalid_names, collapse = ", ")))
})

# Test 2: Check that qbr_total is a positive number less than 100
test_that("qbr_total is a positive number less than 100", {
  invalid_qbr <- data$qbr_total[data$qbr_total <= 0 | data$qbr_total >= 100]
  expect_true(length(invalid_qbr) == 0, info = paste("Invalid qbr_total values: ", paste(invalid_qbr, collapse = ", ")))
})

# Test 3: Check that the team is one of "KC", "NE", or "TB"
test_that("Team is one of 'KC', 'NE', or 'TB'", {
  valid_teams <- c("Chiefs", "Patriots", "Buccaneers")
  invalid_teams <- unique(data$team[!data$team %in% valid_teams])
  expect_true(length(invalid_teams) == 0, info = paste("Invalid teams: ", paste(invalid_teams, collapse = ", ")))
})

# Test 4: Check that qbr_total is a positive number less than 100 (explicit check)
test_that("qbr_total is a positive number less than 100 (explicit check)", {
  expect_true(all(data$qbr_total > 0 & data$qbr_total < 100, na.rm = TRUE), info = "qbr_total is out of range (not positive or greater than 100).")
})

# Print confirmation if tests pass
message("All tests have passed successfully.")
