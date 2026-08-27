#' Shared American Soccer Analysis API client
#'
#' Constructs an [itscalledsoccer::AmericanSoccerAnalysis] R6 client once per R
#' process. The client fetches and caches the players/teams/stadia/managers/
#' referees dimension tables on creation, so reuse matters.
#'
#' @return An `AmericanSoccerAnalysis` object.
#' @noRd
asa_client <- memoise::memoise(function() {
	itscalledsoccer::AmericanSoccerAnalysis$new()
})

#' Seasons to pull from ASA
#'
#' @param through Last season (inclusive). Defaults to the current calendar
#' year.
#' @return Integer vector from [ASA_FIRST_SEASON] to `through`.
#' @noRd
asa_seasons <- function(through = as.integer(format(Sys.Date(), "%Y"))) {
	seq.int(ASA_FIRST_SEASON, max(ASA_FIRST_SEASON, through))
}

#' Flatten a goals-added response into tidy long form
#'
#' `get_player_goals_added()` / `get_goalkeeper_goals_added()` return one row per
#' player (optionally per game) with a nested `data` column holding a data frame
#' of `action_type` / `goals_added_raw` / `goals_added_above_avg` /
#' `count_actions`. This unnests that to one row per player-(game-)action and
#' coerces the sometimes-list `team_id` column to character.
#'
#' @param df A goals-added data frame from `itscalledsoccer`.
#' @return A data frame with the `data` column expanded; `id_cols` preserved.
#' @noRd
unnest_goals_added <- function(df) {
	df <- as.data.frame(df)
	if (!nrow(df) || !"data" %in% names(df)) {
		return(df)
	}

	if (is.list(df$team_id)) {
		df$team_id <- vapply(
			df$team_id,
			function(x) if (length(x)) utils::tail(as.character(x), 1L) else NA_character_,
			character(1)
		)
	}

	id_cols <- setdiff(names(df), "data")
	rows <- Map(
		function(i) {
			inner <- as.data.frame(df$data[[i]])
			if (!nrow(inner)) {
				return(NULL)
			}
			cbind(df[rep(i, nrow(inner)), id_cols, drop = FALSE], inner, row.names = NULL)
		},
		seq_len(nrow(df))
	)
	out <- do.call(rbind, rows)
	rownames(out) <- NULL
	out
}

#' Coerce a possibly-list `team_id` column to character (last team)
#'
#' ASA returns `team_id` as a list column when a player appeared for more than
#' one team and the pull was not split by team. Use `split_by_teams = TRUE`
#' upstream where possible; this is the fallback.
#'
#' @param df A data frame with a `team_id` column.
#' @noRd
flatten_team_id <- function(df) {
	df <- as.data.frame(df)
	if ("team_id" %in% names(df) && is.list(df$team_id)) {
		df$team_id <- vapply(
			df$team_id,
			function(x) if (length(x)) utils::tail(as.character(x), 1L) else NA_character_,
			character(1)
		)
	}
	df
}
