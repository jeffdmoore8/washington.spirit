#' Player-explorer data transforms
#'
#' Small pure helpers that turn the loaded snapshots (see [load_app_data()])
#' into the exact frames each panel of `mod_player_explorer` renders. Kept out
#' of the module so they are unit-testable.
#'
#' @name fct_player
#' @keywords internal
NULL

#' One player-season row from the xGoals season snapshot
#'
#' @param data Result of [load_app_data()].
#' @param player_id ASA player id.
#' @param season 4-digit season.
#' @return A one-row data frame, or an empty frame if not found.
#' @noRd
player_season_xgoals <- function(data, player_id, season) {
	df <- data$player_xgoals_season
	if (is.null(df)) {
		return(data.frame())
	}
	out <- df[df$player_id == player_id & df$season == season, , drop = FALSE]
	# A traded player can have >1 row in a season; keep the Spirit stint.
	if (nrow(out) > 1 && SPIRIT_ASA_TEAM_ID %in% out$team_id) {
		out <- out[out$team_id == SPIRIT_ASA_TEAM_ID, , drop = FALSE]
	}
	out
}

#' Goals-added-by-action breakdown for one player-season
#'
#' @inheritParams player_season_xgoals
#' @return Data frame with `action_type`, `goals_added_raw`,
#' `goals_added_above_avg`, `count_actions`, ordered by above-average impact.
#' Empty if the player is a keeper or has no data.
#' @noRd
player_gplus_actions <- function(data, player_id, season) {
	df <- data$player_gplus_season
	if (is.null(df)) {
		return(data.frame())
	}
	out <- df[df$player_id == player_id & df$season == season, , drop = FALSE]
	if (nrow(out) && SPIRIT_ASA_TEAM_ID %in% out$team_id) {
		out <- out[out$team_id == SPIRIT_ASA_TEAM_ID, , drop = FALSE]
	}
	keep <- intersect(
		c("action_type", "goals_added_raw", "goals_added_above_avg", "count_actions"),
		names(out)
	)
	out <- out[keep]
	out <- out[order(out$goals_added_above_avg), , drop = FALSE]
	rownames(out) <- NULL
	out
}

#' Goalkeeper goals-added-by-action breakdown for one player-season
#'
#' @inheritParams player_season_xgoals
#' @noRd
gk_gplus_actions <- function(data, player_id, season) {
	df <- data$gk_gplus_season
	if (is.null(df)) {
		return(data.frame())
	}
	out <- df[df$player_id == player_id & df$season == season, , drop = FALSE]
	keep <- intersect(
		c("action_type", "goals_added_raw", "goals_added_above_avg", "count_actions"),
		names(out)
	)
	out <- out[keep]
	out <- out[order(out$goals_added_above_avg), , drop = FALSE]
	rownames(out) <- NULL
	out
}

#' Is this player a goalkeeper in the given season?
#'
#' @inheritParams player_season_xgoals
#' @noRd
player_is_gk <- function(data, player_id, season) {
	gk <- data$gk_xgoals_season
	if (!is.null(gk) && any(gk$player_id == player_id & gk$season == season)) {
		return(TRUE)
	}
	row <- player_season_xgoals(data, player_id, season)
	nrow(row) > 0 && isTRUE(row$general_position[1] == "GK")
}

#' Percentile bars for one player-season vs. positional peers
#'
#' Joins the xGoals and xPass season snapshots, converts counting stats to
#' per-90, ranks every metric within `general_position` via
#' [add_positional_percentiles()], and returns the selected player's row in long
#' form ready to plot.
#'
#' @inheritParams player_season_xgoals
#' @return Data frame with `metric` (label), `percentile` (0-100), `value`
#' (the player's raw per-90 / rate value). Empty if the player-season is missing.
#' @noRd
player_percentiles <- function(data, player_id, season) {
	xg <- data$player_xgoals_season
	xp <- data$player_xpass_season
	if (is.null(xg)) {
		return(data.frame())
	}

	pool <- xg[xg$season == season, , drop = FALSE]
	if (!nrow(pool)) {
		return(data.frame())
	}

	pool$goals_p90 <- per90(pool$goals, pool$minutes_played)
	pool$xg_p90 <- per90(pool$xgoals, pool$minutes_played)
	pool$xa_p90 <- per90(pool$xassists, pool$minutes_played)
	pool$shots_p90 <- per90(pool$shots, pool$minutes_played)
	pool$key_passes_p90 <- per90(pool$key_passes, pool$minutes_played)
	pool$xg_xa_p90 <- per90(pool$xgoals_plus_xassists, pool$minutes_played)
	pool$g_minus_xg <- pool$goals_minus_xgoals

	if (!is.null(xp)) {
		xp_season <- xp[xp$season == season, c("player_id", "team_id", "passes_completed_over_expected_p100", "share_team_touches")]
		pool <- merge(pool, xp_season, by = c("player_id", "team_id"), all.x = TRUE)
	}

	metrics <- c(
		"xg_p90", "xa_p90", "xg_xa_p90", "shots_p90", "key_passes_p90",
		"goals_p90", "g_minus_xg", "passes_completed_over_expected_p100",
		"share_team_touches"
	)
	pool <- add_positional_percentiles(pool, metrics)

	row <- pool[pool$player_id == player_id, , drop = FALSE]
	if (nrow(row) > 1 && SPIRIT_ASA_TEAM_ID %in% row$team_id) {
		row <- row[row$team_id == SPIRIT_ASA_TEAM_ID, , drop = FALSE]
	}
	if (!nrow(row)) {
		return(data.frame())
	}
	row <- row[1, , drop = FALSE]

	labels <- c(
		xg_p90 = "xG per 90",
		xa_p90 = "xA per 90",
		xg_xa_p90 = "xG+xA per 90",
		shots_p90 = "Shots per 90",
		key_passes_p90 = "Key passes per 90",
		goals_p90 = "Goals per 90",
		g_minus_xg = "Finishing (G − xG)",
		passes_completed_over_expected_p100 = "Passing vs. expected (per 100)",
		share_team_touches = "Share of team touches"
	)

	present <- metrics[metrics %in% names(row) & paste0(metrics, "_pct") %in% names(row)]
	data.frame(
		metric = unname(labels[present]),
		percentile = as.numeric(row[paste0(present, "_pct")]),
		value = as.numeric(row[present]),
		stringsAsFactors = FALSE
	)
}

#' Per-game goals-added series for one Spirit player-season (form/trend)
#'
#' Sums the unnested per-game goals-added rows back to one total per game and
#' orders them chronologically where a `game_id`-derived order is available.
#'
#' @inheritParams player_season_xgoals
#' @param roll Rolling-mean window (games). `NULL` disables the rolling column.
#' @return Data frame with `game_id`, `game_no`, `gplus`, and (if `roll`)
#' `gplus_roll`.
#' @noRd
player_form <- function(data, player_id, season, roll = 5) {
	df <- data$player_gplus_game
	if (is.null(df) || !"game_id" %in% names(df)) {
		return(data.frame())
	}
	sub <- df[df$player_id == player_id, , drop = FALSE]
	if ("season" %in% names(sub)) {
		sub <- sub[sub$season == season, , drop = FALSE]
	}
	if (!nrow(sub)) {
		return(data.frame())
	}

	agg <- stats::aggregate(
		goals_added_raw ~ game_id,
		data = sub,
		FUN = function(x) sum(x, na.rm = TRUE)
	)
	names(agg)[2] <- "gplus"

	# Order chronologically by kickoff where refresh_data.R tagged it; otherwise
	# fall back to the API's (already chronological) input order.
	if ("date_time_utc" %in% names(sub)) {
		kickoff <- sub$date_time_utc[match(agg$game_id, sub$game_id)]
		agg <- agg[order(kickoff), , drop = FALSE]
	} else {
		first_seen <- match(agg$game_id, unique(sub$game_id))
		agg <- agg[order(first_seen), , drop = FALSE]
	}
	agg$game_no <- seq_len(nrow(agg))

	if (!is.null(roll) && nrow(agg) >= 1) {
		agg$gplus_roll <- as.numeric(
			stats::filter(agg$gplus, rep(1 / roll, roll), sides = 1)
		)
	}
	rownames(agg) <- NULL
	out <- agg[, c("game_id", "game_no", "gplus", if (!is.null(roll)) "gplus_roll")]
	attr(out, "roll") <- roll
	out
}
