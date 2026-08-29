#' Roster / headshot helpers
#'
#' The Washington Spirit's own site lazy-loads date-stamped headshot files
#' behind Cloudflare, so we take headshots from ESPN's stable player CDN
#' (`a.espncdn.com/i/headshots/...`) instead. `data-raw/refresh_data.R` fetches
#' the ESPN roster, matches each athlete to an American Soccer Analysis
#' `player_id` by normalised name, and writes `roster.parquet`.
#'
#' @name fct_roster
#' @keywords internal
#' @importFrom httr GET user_agent stop_for_status content
#' @importFrom jsonlite fromJSON
NULL

#' Normalise a personal name for matching across data sources
#'
#' Lower-cases, transliterates accents to ASCII (an accented "Elisabeth"
#' becomes "elisabeth"), drops anything that is not a letter or space, and
#' collapses whitespace.
#'
#' @param x Character vector of names.
#' @return Character vector.
#' @noRd
normalize_name <- function(x) {
	x <- as.character(x)
	x <- iconv(x, to = "ASCII//TRANSLIT")
	x <- tolower(x)
	x <- gsub("[-_]", " ", x)
	# Drop everything else, including the apostrophes/carets that //TRANSLIT
	# leaves where an accented letter was (an accented "e" -> "'e").
	x <- gsub("[^a-z ]", "", x)
	x <- gsub("\\s+", " ", x)
	trimws(x)
}

#' ESPN NWSL roster for a team, with headshots
#'
#' @param espn_team_id ESPN team id (default: the Spirit).
#' @return Data frame: `espn_id`, `espn_name`, `jersey`, `position`,
#' `headshot_url`. `NULL` on any failure.
#' @noRd
fetch_espn_roster <- function(espn_team_id = SPIRIT_ESPN_TEAM_ID) {
	url <- sprintf(
		"https://site.api.espn.com/apis/site/v2/sports/soccer/usa.nwsl/teams/%s/roster",
		espn_team_id
	)
	res <- tryCatch(
		{
			# ESPN's WAF 403s "browser-like" and libcurl user agents but serves
			# plain curl UAs fine.
			resp <- httr::GET(url, httr::user_agent("curl/8"))
			httr::stop_for_status(resp)
			jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
		},
		error = function(e) NULL
	)
	ath <- res$athletes
	if (is.null(ath) || !NROW(ath)) {
		return(NULL)
	}
	data.frame(
		espn_id = as.character(ath$id),
		espn_name = as.character(ath$displayName),
		jersey = suppressWarnings(as.integer(ath$jersey)),
		position = as.character(ath$position$abbreviation),
		headshot_url = ifelse(
			is.na(ath$headshot$href),
			sprintf("https://a.espncdn.com/i/headshots/soccer/players/full/%s.png", ath$id),
			as.character(ath$headshot$href)
		),
		stringsAsFactors = FALSE
	)
}

#' Headshot URL for one player, or `NULL`
#'
#' @param data Result of [load_app_data()].
#' @param player_id ASA player id.
#' @noRd
player_headshot <- function(data, player_id) {
	r <- data$roster
	if (is.null(r) || !"headshot_url" %in% names(r)) {
		return(NULL)
	}
	hit <- r$headshot_url[r$player_id == player_id]
	hit <- hit[!is.na(hit) & nzchar(hit)]
	if (length(hit)) hit[1] else NULL
}

#' Squad-number / position label for one player, or `NULL`
#'
#' @inheritParams player_headshot
#' @noRd
player_badge <- function(data, player_id) {
	r <- data$roster
	if (is.null(r)) {
		return(NULL)
	}
	row <- r[r$player_id == player_id, , drop = FALSE]
	if (!nrow(row)) {
		return(NULL)
	}
	parts <- c(
		if (!is.na(row$jersey[1])) paste0("#", row$jersey[1]),
		if (!is.na(row$position[1]) && nzchar(row$position[1])) row$position[1]
	)
	if (length(parts)) paste(parts, collapse = " - ") else NULL
}
