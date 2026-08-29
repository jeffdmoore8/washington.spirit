# =============================================================================
# refresh_data.R - rebuild the app's data snapshots from American Soccer Analysis
#
# Pulls every NWSL season ASA covers (2016+), writes tidy parquet files to
# inst/extdata/ where load_app_data() reads them. League-wide season tables are
# kept whole (needed for positional percentile ranks); per-game tables are
# filtered to the Washington Spirit.
#
# Run:  Rscript data-raw/refresh_data.R
# CI:   .github/workflows/refresh-data.yaml (scheduled, commits the result)
# =============================================================================

pkgload::load_all(helpers = FALSE, attach_testthat = FALSE)

suppressPackageStartupMessages({
	library(dplyr)
	library(tidyr)
})

out_dir <- file.path(pkgload::pkg_path(), "inst", "extdata")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

seasons <- asa_seasons()
seasons_chr <- as.character(seasons)
asa <- asa_client()

message("Refreshing ASA snapshots for seasons ", min(seasons), "-", max(seasons))

write_snapshot <- function(df, slot) {
	file <- APP_DATA_FILES[[slot]]
	stopifnot(!is.null(file))
	df <- as.data.frame(df)
	# Keep `season` an integer across every snapshot: the API returns it as a
	# string on the *_by_season endpoints and the game lookup carries it as int.
	if ("season" %in% names(df)) {
		df$season <- as.integer(df$season)
	}
	path <- file.path(out_dir, file)
	arrow::write_parquet(df, path)
	message(sprintf("  %-28s %6d rows  ->  %s", slot, nrow(df), file))
	invisible(path)
}

# --- dimension tables --------------------------------------------------------
players <- asa$get_players(leagues = "nwsl")
teams <- asa$get_teams(leagues = "nwsl")
write_snapshot(players, "players")
write_snapshot(teams, "teams")

games <- asa$get_games(leagues = "nwsl", seasons = seasons_chr) |>
	rename(season = season_name) |>
	mutate(season = as.integer(.data$season))
write_snapshot(games, "games")

# game_id -> season / kickoff, for tagging the per-game player tables (the
# split_by_games endpoints do not return a season column).
game_lookup <- games |>
	select("game_id", "season", "date_time_utc") |>
	distinct()

tag_games <- function(df) {
	df |>
		select(-dplyr::any_of("season")) |>
		left_join(game_lookup, by = "game_id")
}

# --- player season tables (league-wide, for percentile context) -------------
player_xgoals_season <- asa$get_player_xgoals(
	leagues = "nwsl",
	season_name = seasons_chr,
	split_by_seasons = TRUE,
	split_by_teams = TRUE
) |>
	flatten_team_id() |>
	rename(season = season_name) |>
	left_join(select(players, player_id, player_name), by = "player_id")
write_snapshot(player_xgoals_season, "player_xgoals_season")

player_xpass_season <- asa$get_player_xpass(
	leagues = "nwsl",
	season_name = seasons_chr,
	split_by_seasons = TRUE,
	split_by_teams = TRUE
) |>
	flatten_team_id() |>
	rename(season = season_name) |>
	left_join(select(players, player_id, player_name), by = "player_id")
write_snapshot(player_xpass_season, "player_xpass_season")

player_gplus_season <- asa$get_player_goals_added(
	leagues = "nwsl",
	season_name = seasons_chr,
	split_by_seasons = TRUE,
	split_by_teams = TRUE
) |>
	rename(season = season_name) |>
	unnest_goals_added() |>
	left_join(select(players, player_id, player_name), by = "player_id")
write_snapshot(player_gplus_season, "player_gplus_season")

# --- player per-game tables (Spirit only, for form/trend) -------------------
# team_ids filter keeps this to a handful of fast requests; pulling every NWSL
# game across all seasons times out.
player_gplus_game <- asa$get_player_goals_added(
	leagues = "nwsl",
	season_name = seasons_chr,
	team_ids = SPIRIT_ASA_TEAM_ID,
	split_by_games = TRUE
) |>
	unnest_goals_added() |>
	tag_games() |>
	left_join(select(players, player_id, player_name), by = "player_id")
write_snapshot(player_gplus_game, "player_gplus_game")

player_xgoals_game <- asa$get_player_xgoals(
	leagues = "nwsl",
	season_name = seasons_chr,
	team_ids = SPIRIT_ASA_TEAM_ID,
	split_by_games = TRUE
) |>
	flatten_team_id() |>
	tag_games() |>
	left_join(select(players, player_id, player_name), by = "player_id")
write_snapshot(player_xgoals_game, "player_xgoals_game")

# --- goalkeeper season tables ---------------------------------------------------
gk_gplus_season <- asa$get_goalkeeper_goals_added(
	leagues = "nwsl",
	season_name = seasons_chr,
	split_by_seasons = TRUE,
	split_by_teams = TRUE
) |>
	rename(season = season_name) |>
	unnest_goals_added() |>
	left_join(select(players, player_id, player_name), by = "player_id")
write_snapshot(gk_gplus_season, "gk_gplus_season")

gk_xgoals_season <- asa$get_goalkeeper_xgoals(
	leagues = "nwsl",
	season_name = seasons_chr,
	split_by_seasons = TRUE,
	split_by_teams = TRUE
) |>
	flatten_team_id() |>
	rename(season = season_name) |>
	left_join(select(players, player_id, player_name), by = "player_id")
write_snapshot(gk_xgoals_season, "gk_xgoals_season")

# --- team season tables -------------------------------------------------------
team_xgoals_season <- asa$get_team_xgoals(
	leagues = "nwsl",
	season_name = seasons_chr,
	split_by_seasons = TRUE
) |>
	flatten_team_id() |>
	rename(season = season_name) |>
	left_join(select(teams, team_id, team_name), by = "team_id")
write_snapshot(team_xgoals_season, "team_xgoals_season")

team_gplus <- asa$get_team_goals_added(
	leagues = "nwsl",
	season_name = seasons_chr,
	split_by_seasons = TRUE
) |>
	rename(season = season_name) |>
	unnest_goals_added() |>
	left_join(select(teams, team_id, team_name), by = "team_id")
write_snapshot(team_gplus, "team_gplus")

# --- roster + headshots (ESPN) ---------------------------------------------
# Match the ESPN roster to ASA player_ids by normalised name. Where a name is
# not unique in the ASA players table, prefer the player who has actually
# logged Spirit minutes.
espn_roster <- fetch_espn_roster()
if (is.null(espn_roster)) {
	message("  roster                       ESPN roster fetch failed - skipping")
} else {
	spirit_player_ids <- unique(
		player_xgoals_season$player_id[player_xgoals_season$team_id == SPIRIT_ASA_TEAM_ID]
	)
	asa_lookup <- players |>
		mutate(norm = normalize_name(.data$player_name)) |>
		mutate(has_spirit_history = .data$player_id %in% spirit_player_ids) |>
		arrange(dplyr::desc(.data$has_spirit_history)) |>
		distinct(.data$norm, .keep_all = TRUE) |>
		select("norm", "player_id", asa_name = "player_name")

	roster <- espn_roster |>
		mutate(norm = normalize_name(.data$espn_name)) |>
		left_join(asa_lookup, by = "norm") |>
		select(
			"player_id", "espn_id", asa_name = "asa_name", "espn_name",
			"jersey", "position", "headshot_url"
		)

	unmatched <- roster$espn_name[is.na(roster$player_id)]
	if (length(unmatched)) {
		message("  roster: no ASA match for ", paste(unmatched, collapse = ", "))
	}
	write_snapshot(roster, "roster")
}

# --- meta ------------------------------------------------------------------
meta <- data.frame(
	refreshed_at = format(Sys.time(), tz = "UTC", usetz = TRUE),
	seasons_from = min(seasons),
	seasons_to = max(seasons),
	itscalledsoccer_version = as.character(utils::packageVersion("itscalledsoccer"))
)
write_snapshot(meta, "meta")

message("Done. ", length(list.files(out_dir, pattern = "\\.parquet$")), " snapshot files in ", out_dir)
