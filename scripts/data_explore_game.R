library(ggplot2)
library(dplyr)
library(arrow)

# Load and filter data
data <- read_parquet("~/nfl/data/analysis_data/game_stats/merged_player_game.parquet")
data_filtered <- data %>% filter(player_display_name %in% c("Tom Brady", "Patrick Mahomes"))

# 1. Distribution of Fantasy Points
p1 <- ggplot(data_filtered, aes(x = fantasy_points, fill = player_display_name)) +
  geom_histogram(binwidth = 1, alpha = 0.7, position = "identity") +
  labs(title = "Distribution of Fantasy Points: Mahomes vs Brady", x = "Fantasy Points", y = "Count") +
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

# 2. Passing Yards
p2 <- data_filtered %>%
  group_by(player_display_name) %>%
  summarise(total_passing_yards = sum(passing_yards, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = player_display_name, y = total_passing_yards, fill = player_display_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Passing Yards: Mahomes vs Brady", x = "Player", y = "Passing Yards") +
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

# 3. Passing Yards vs Fantasy Points
p3 <- ggplot(data_filtered, aes(x = passing_yards, y = fantasy_points, color = player_display_name)) +
  geom_point(alpha = 0.7) +
  labs(title = "Passing Yards vs Fantasy Points: Mahomes vs Brady", x = "Passing Yards", y = "Fantasy Points") +
  scale_color_manual(values = c("blue", "red")) +
  theme_minimal()

# 4. Passing TDs by Week
p4 <- data_filtered %>%
  group_by(week, player_display_name) %>%
  summarise(total_passing_tds = sum(passing_tds, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = week, y = total_passing_tds, color = player_display_name, group = player_display_name)) +
  geom_line(size = 1) +
  labs(title = "Passing TDs by Week: Mahomes vs Brady", x = "Week", y = "Passing TDs") +
  scale_color_manual(values = c("blue", "red")) +
  theme_minimal()

# 5. Rushing Yards by Player Position
p5 <- data_filtered %>%
  group_by(player_display_name) %>%
  summarise(total_rushing_yards = sum(rushing_yards, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = player_display_name, y = total_rushing_yards, fill = player_display_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Rushing Yards: Mahomes vs Brady", x = "Player", y = "Rushing Yards") +
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

# 6. Receiving Yards vs Targets
p6 <- ggplot(data_filtered, aes(x = targets, y = receiving_yards, color = player_display_name)) +
  geom_point(alpha = 0.7) +
  labs(title = "Receiving Yards vs Targets: Mahomes vs Brady", x = "Targets", y = "Receiving Yards") +
  scale_color_manual(values = c("blue", "red")) +
  theme_minimal()

# 7. Total Fantasy Points by Season
p7 <- data_filtered %>%
  group_by(season, player_display_name) %>%
  summarise(total_fantasy_points = sum(fantasy_points, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = season, y = total_fantasy_points, fill = player_display_name)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Fantasy Points by Season: Mahomes vs Brady", x = "Season", y = "Fantasy Points") +
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

# 8. Average Passing Yards by Opponent Team
p8 <- data_filtered %>%
  group_by(opponent_team, player_display_name) %>%
  summarise(avg_passing_yards = mean(passing_yards, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = reorder(opponent_team, avg_passing_yards), y = avg_passing_yards, fill = player_display_name)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Avg Passing Yards by Opponent: Mahomes vs Brady", x = "Opponent Team", y = "Avg Passing Yards") +
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

# Display all the plots
print(p1)
print(p2)
print(p3)
print(p4)
print(p5)
print(p6)
print(p7)
print(p8)