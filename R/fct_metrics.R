#' Percentile rank of each value within a vector
#'
#' Returns values on a 0-100 scale where 100 is the best. Ties share the mean
#' rank. `NA` inputs stay `NA` and are excluded from the ranking population.
#'
#' @param x Numeric vector.
#' @param na.rm Ignored; kept for symmetry with base summarisers. `NA` values are
#' always dropped from the population and returned as `NA`.
#'
#' @return Numeric vector the same length as `x`.
#'
#' @examples
#' pct_rank(c(1, 2, 3, 4, 5)) # -> 10 30 50 70 90
#' @noRd
pct_rank <- function(x, na.rm = TRUE) {
	out <- rep(NA_real_, length(x))
	ok <- !is.na(x)
	n <- sum(ok)
	if (n == 0) {
		return(out)
	}
	if (n == 1) {
		out[ok] <- 50
		return(out)
	}
	# rank() with averaged ties, scaled so the population spans (0, 100) without
	# putting the extreme values exactly on the boundary.
	out[ok] <- (rank(x[ok], ties.method = "average") - 0.5) / n * 100
	out
}

#' Per-90-minutes rate
#'
#' @param value Numeric count or value accumulated over `minutes`.
#' @param minutes Minutes played.
#' @param min_minutes Below this, return `NA` (rates on tiny samples mislead).
#'
#' @return Numeric vector.
#' @noRd
per90 <- function(value, minutes, min_minutes = 180) {
	out <- value / (minutes / 90)
	out[is.na(minutes) | minutes < min_minutes] <- NA_real_
	out
}

#' Attach positional percentile columns to a league-wide season table
#'
#' For each metric, computes [pct_rank()] within rows sharing the same
#' `group` value (typically `general_position`), after filtering to a minutes
#' floor so bench players do not distort the distribution. Percentile columns
#' are named `<metric>_pct`.
#'
#' @param df Data frame of one row per player-season (league-wide).
#' @param metrics Character vector of numeric column names to rank.
#' @param group Column defining the comparison peer group.
#' @param minutes_col Minutes column used for the sample floor.
#' @param min_minutes Minimum minutes to be included in the ranked population.
#'
#' @return `df` with one added `<metric>_pct` column per metric. Rows below the
#' minutes floor get `NA` percentiles but are retained.
#' @noRd
add_positional_percentiles <- function(
	df,
	metrics,
	group = "general_position",
	minutes_col = "minutes_played",
	min_minutes = 450
) {
	metrics <- intersect(metrics, names(df))
	if (!nrow(df) || !length(metrics) || !group %in% names(df)) {
		return(df)
	}

	eligible <- !is.na(df[[minutes_col]]) & df[[minutes_col]] >= min_minutes
	grp <- df[[group]]

	for (m in metrics) {
		col <- rep(NA_real_, nrow(df))
		vals <- df[[m]]
		vals[!eligible] <- NA_real_
		for (g in unique(grp[eligible])) {
			idx <- which(grp == g)
			col[idx] <- pct_rank(vals[idx])
		}
		df[[paste0(m, "_pct")]] <- col
	}
	df
}

#' Current Washington Spirit roster for a season
#'
#' Derives the roster from whichever player-season tables are present in the
#' loaded data: a player appears if they logged minutes for the Spirit in the
#' requested season in the xGoals or goals-added season snapshots.
#'
#' @param data Result of [load_app_data()].
#' @param season 4-digit season, or `NULL` for the most recent season present.
#'
#' @return Data frame with `player_id`, `player_name`, `general_position`,
#' `minutes_played`, `season`, ordered by minutes played descending.
#' @noRd
spirit_roster <- function(data, season = NULL) {
	src <- data$player_xgoals_season
	if (is.null(src)) {
		src <- data$player_gplus_season
	}
	if (is.null(src) || !nrow(src)) {
		return(data.frame())
	}

	src <- src[src$team_id == SPIRIT_ASA_TEAM_ID, , drop = FALSE]
	if (is.null(season)) {
		season <- max(src$season, na.rm = TRUE)
	}
	src <- src[src$season == season, , drop = FALSE]

	keep <- intersect(
		c("player_id", "player_name", "general_position", "minutes_played", "season"),
		names(src)
	)
	src <- src[order(-src$minutes_played), keep, drop = FALSE]
	rownames(src) <- NULL
	src
}

#' Seasons available for the Spirit, newest first
#'
#' @param data Result of [load_app_data()].
#' @noRd
spirit_seasons <- function(data) {
	src <- data$player_xgoals_season
	if (is.null(src)) {
		src <- data$player_gplus_season
	}
	if (is.null(src) || !nrow(src)) {
		return(integer())
	}
	seasons <- src$season[src$team_id == SPIRIT_ASA_TEAM_ID]
	sort(unique(seasons[!is.na(seasons)]), decreasing = TRUE)
}
