#### Preamble ####
# Purpose: Tests simulated NFL QBR data for Tom Brady and Patrick Mahomes
# Author: Alexander Guarasci
# Date: 26 November 2024
# Contact: alexander.guarasci@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `dplyr`, `arrow` and 'testthat' packages must be installed, and simulate_qbr_data.R must be run


# Load necessary libraries
library(dplyr)
library(arrow)
library(testthat)

# Set the file path
file_path <- "~/nfl/data/simulated_data/simulated_qbr_data.parquet"

# Load the data
data <- read_parquet(file_path)


# Test 1: Check if the 'rank' column has values between 1 and 10
test_that("Rank values are between 1 and 10", {
  expect_true(all(data$rank >= 1 & data$rank <= 10, na.rm = TRUE))
})

# Test 2: Check if the 'qualified' column is a logical (TRUE/FALSE)
test_that("Qualified column is logical", {
  expect_true(all(is.logical(data$qualified)))
})

# Test 3: Check if the 'season' column contains values between 2000 and 2024
test_that("Season values are between 2000 and 2024", {
  expect_true(all(data$season >= 2000 & data$season <= 2024, na.rm = TRUE))
})

# Test 4: Check if 'qbr_total' contains no missing values (NA)
test_that("qbr_total has no missing values", {
  expect_true(all(!is.na(data$qbr_total)))
})

# Print confirmation if tests pass
message("All tests have passed successfully.")