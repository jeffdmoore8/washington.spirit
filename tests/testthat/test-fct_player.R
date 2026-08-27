fake_data <- function() {
	list(
		player_xgoals_season = data.frame(
			player_id = c("p1", "p1", "p2"),
			team_id = c(SPIRIT_ASA_TEAM_ID, "other", SPIRIT_ASA_TEAM_ID),
			season = c(2024L, 2024L, 2024L),
			player_name = c("Player One", "Player One", "Player Two"),
			general_position = c("W", "W", "GK"),
			minutes_played = c(1800, 200, 2600),
			shots = c(40, 5, 0),
			shots_on_target = c(18, 2, 0),
			goals = c(9, 1, 0),
			xgoals = c(7.5, 0.6, 0),
			goals_minus_xgoals = c(1.5, 0.4, 0),
			xassists = c(3.1, 0.2, 0),
			key_passes = c(30, 3, 0),
			xgoals_plus_xassists = c(10.6, 0.8, 0),
			stringsAsFactors = FALSE
		),
		player_gplus_season = data.frame(
			player_id = rep("p1", 3),
			team_id = rep(SPIRIT_ASA_TEAM_ID, 3),
			season = rep(2024L, 3),
			action_type = c("Passing", "Shooting", "Receiving"),
			goals_added_raw = c(-0.3, 1.2, 0.8),
			goals_added_above_avg = c(-0.5, 0.9, 0.2),
			count_actions = c(900, 40, 700),
			stringsAsFactors = FALSE
		),
		gk_xgoals_season = data.frame(
			player_id = "p2", season = 2024L,
			goals_divided_by_xgoals_gk = 0.82,
			stringsAsFactors = FALSE
		),
		player_gplus_game = data.frame(
			player_id = rep("p1", 6),
			game_id = rep(c("g1", "g2", "g3"), each = 2),
			season = rep(2024L, 6),
			date_time_utc = rep(c("2024-04-01", "2024-03-01", "2024-05-01"), each = 2),
			action_type = rep(c("Passing", "Shooting"), 3),
			goals_added_raw = c(0.1, 0.2, -0.1, 0.0, 0.3, 0.4),
			stringsAsFactors = FALSE
		)
	)
}

test_that("player_season_xgoals picks the Spirit stint for a traded player", {
	row <- player_season_xgoals(fake_data(), "p1", 2024)
	expect_equal(nrow(row), 1)
	expect_equal(row$team_id, SPIRIT_ASA_TEAM_ID)
	expect_equal(row$minutes_played, 1800)
})

test_that("player_gplus_actions returns the action breakdown sorted by impact", {
	acts <- player_gplus_actions(fake_data(), "p1", 2024)
	expect_equal(nrow(acts), 3)
	expect_equal(acts$action_type[1], "Passing") # most negative first
	expect_equal(sum(acts$goals_added_raw), 1.7, tolerance = 1e-8)
})

test_that("player_is_gk detects keepers by position and by the GK table", {
	expect_true(player_is_gk(fake_data(), "p2", 2024))
	expect_false(player_is_gk(fake_data(), "p1", 2024))
})

test_that("player_percentiles returns long rows with a value per metric", {
	pct <- player_percentiles(fake_data(), "p1", 2024)
	expect_true(all(c("metric", "percentile", "value") %in% names(pct)))
	expect_gt(nrow(pct), 0)
})

test_that("player_form aggregates per game and orders by kickoff", {
	form <- player_form(fake_data(), "p1", 2024, roll = 2)
	expect_equal(form$game_id, c("g2", "g1", "g3")) # chronological by date
	expect_equal(form$gplus[form$game_id == "g1"], 0.3, tolerance = 1e-8)
})
