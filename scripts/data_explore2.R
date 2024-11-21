
# 3. Calculate passing touchdowns per season for each player
passing_tds_per_season <- data %>%
  group_by(player_name, season) %>%
  summarize(total_passing_tds = sum(passing_tds, na.rm = TRUE))

# Plot passing touchdowns per season for both players
passing_tds_plot <- ggplot(passing_tds_per_season, aes(x = season, y = total_passing_tds, color = player_name)) +
  geom_line() +
  labs(title = "Passing Touchdowns per Season", x = "Season", y = "Total Passing Touchdowns") +
  theme_minimal()

# 4. Calculate interceptions per season for each player
interceptions_per_season <- data %>%
  group_by(player_name, season) %>%
  summarize(total_interceptions = sum(interceptions, na.rm = TRUE))

# Plot interceptions per season for both players
interceptions_plot <- ggplot(interceptions_per_season, aes(x = season, y = total_interceptions, color = player_name)) +
  geom_line() +
  labs(title = "Interceptions per Season", x = "Season", y = "Total Interceptions") +
  theme_minimal()


print(passing_yards_plot)
print(passing_tds_plot)
print(interceptions_plot)