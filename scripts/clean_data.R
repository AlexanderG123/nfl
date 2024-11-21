# Install necessary packages if not already installed
if (!requireNamespace("arrow", quietly = TRUE)) {
  install.packages("arrow")
}

library(arrow)
library(dplyr)

# Load the player statistics data for different years and types
# Adjust file paths to where your actual data is stored

# Game Stats (00s, 10s, 20s, current)
player_stats_00s <- read_parquet("~/nfl/data/raw_data/game_stats/player_game_00s.parquet")
player_stats_10s <- read_parquet("~/nfl/data/raw_data/game_stats/player_game_10s.parquet")
player_stats_20s <- read_parquet("~/nfl/data/raw_data/game_stats/player_game_20s.parquet")
player_stats_current <- read_parquet("~/nfl/data/raw_data/game_stats/player_game_current.parquet")

# Advanced Stats (QBR, Next Gen)
qbr_2024 <- read_parquet("~/nfl/data/raw_data/advanced_stats/qbr_2024.parquet")
qbr_06_23 <- read_parquet("~/nfl/data/raw_data/advanced_stats/qbr_06_23.parquet")
nextgen_stats <- read_parquet("~/nfl/data/raw_data/advanced_stats/next_gen.parquet")

# Filter for Tom Brady and Patrick Mahomes in each dataset
# Adjust the column name based on the file structure

# Game stats (00s, 10s, 20s, current) - Column name is "player_display_name"
game_stats_filtered_00s <- player_stats_00s %>%
  filter(player_display_name %in% c("Tom Brady", "Patrick Mahomes"))

game_stats_filtered_10s <- player_stats_10s %>%
  filter(player_display_name %in% c("Tom Brady", "Patrick Mahomes"))

game_stats_filtered_20s <- player_stats_20s %>%
  filter(player_display_name %in% c("Tom Brady", "Patrick Mahomes"))

game_stats_filtered_current <- player_stats_current %>%
  filter(player_display_name %in% c("Tom Brady", "Patrick Mahomes"))

# Advanced stats (QBR, Next Gen) - Column name is "name_display"
qbr_2024_filtered <- qbr_2024 %>%
  filter(name_display %in% c("Tom Brady", "Patrick Mahomes"))

qbr_06_23_filtered <- qbr_06_23 %>%
  filter(name_display %in% c("Tom Brady", "Patrick Mahomes"))

nextgen_stats_filtered <- nextgen_stats %>%
  filter(player_display_name %in% c("Tom Brady", "Patrick Mahomes"))

# Merge QBR files (filtered_qbr_2024.parquet and filtered_qbr_06_23.parquet)
qbr_merged <- bind_rows(qbr_2024_filtered, qbr_06_23_filtered)

# Merge Game Stats files (filtered_player_game_00s.parquet, filtered_player_game_10s.parquet, filtered_player_game_20s.parquet, filtered_player_game_current.parquet)
game_stats_merged <- bind_rows(game_stats_filtered_00s, game_stats_filtered_10s, game_stats_filtered_20s, game_stats_filtered_current)

# Save the merged data to new Parquet files
write_parquet(qbr_merged, "~/nfl/data/analysis_data/advanced_stats/merged_qbr.parquet")
write_parquet(game_stats_merged, "~/nfl/data/analysis_data/game_stats/merged_player_game.parquet")

# Message to confirm success
message("Merged data for QBR and Game Stats for Tom Brady and Patrick Mahomes has been successfully saved!")

