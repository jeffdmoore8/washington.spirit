#' Washington Spirit's American Soccer Analysis team id
#'
#' Stable across the ASA API; used to filter league-wide pulls down to the
#' Spirit in `data-raw/refresh_data.R` and in the app.
#'
#' @noRd
SPIRIT_ASA_TEAM_ID <- "aDQ0lzvQEv"

#' Washington Spirit's ESPN team id (NWSL)
#'
#' Used to highlight the Spirit row in the live league-table module.
#'
#' @noRd
SPIRIT_ESPN_TEAM_ID <- "15365"

#' First NWSL season with American Soccer Analysis coverage
#'
#' Earlier seasons return zero rows from the API.
#'
#' @noRd
ASA_FIRST_SEASON <- 2016L

#' Names of the snapshot files produced by `data-raw/refresh_data.R`
#'
#' Each entry is `<list slot> = <file name in inst/extdata>`. [load_app_data()]
#' reads every file that exists into a named list under the slot name. All
#' snapshots come from American Soccer Analysis via `itscalledsoccer`.
#'
#' @noRd
APP_DATA_FILES <- c(
	meta                 = "meta.parquet",
	players              = "players.parquet",
	teams                = "teams.parquet",
	games                = "games.parquet",
	roster               = "roster.parquet",
	player_xgoals_season = "player_xgoals_by_season.parquet",
	player_xpass_season  = "player_xpass_by_season.parquet",
	player_gplus_season  = "player_goals_added_by_season.parquet",
	player_gplus_game    = "player_goals_added_by_game.parquet",
	player_xgoals_game   = "player_xgoals_by_game.parquet",
	gk_gplus_season      = "gk_goals_added_by_season.parquet",
	gk_xgoals_season     = "gk_xgoals_by_season.parquet",
	team_xgoals_season   = "team_xgoals_by_season.parquet",
	team_gplus           = "team_goals_added.parquet"
)

#' Read one snapshot file, or `NULL` if it is missing
#'
#' @param file File name within `inst/extdata`.
#' @noRd
read_snapshot <- function(file) {
	path <- app_data_path(file)
	if (!nzchar(path) || !file.exists(path)) {
		return(NULL)
	}
	# arrow returns ALTREP columns that hold pointers into Arrow's C++ memory.
	# load_app_data() is memoised for the life of the process, so those columns
	# stay reachable until R exits — at which point covr's on-exit saveRDS()
	# segfaults touching them after Arrow's runtime has been torn down. Force
	# full materialization on read so the frame is plain R vectors.
	old <- options(arrow.use_altrep = FALSE)
	on.exit(options(old), add = TRUE)
	as.data.frame(arrow::read_parquet(path))
}

#' Load every available data snapshot into a named list
#'
#' Reads the pre-cached parquet snapshots written by `data-raw/refresh_data.R`
#' from `inst/extdata`. Missing files yield a `NULL` slot so the UI can degrade
#' gracefully. The result is memoised for the life of the R process, so this is
#' cheap to call from every module server.
#'
#' @return A named list following [APP_DATA_FILES]. `attr(x, "loaded_at")` holds
#' the read time; the `meta` slot (if present) holds the snapshot's own
#' `refreshed_at` stamp.
#'
#' @noRd
load_app_data_impl <- function() {
	out <- lapply(APP_DATA_FILES, read_snapshot)
	names(out) <- names(APP_DATA_FILES)

	missing <- names(out)[vapply(out, is.null, logical(1))]
	if (length(missing)) {
		rlang::warn(
			paste0(
				"Missing data snapshot(s): ", paste(missing, collapse = ", "),
				". Run data-raw/refresh_data.R to (re)build them."
			),
			class = "washington_spirit_missing_snapshot"
		)
	}

	attr(out, "loaded_at") <- Sys.time()
	out
}

#' @noRd
load_app_data <- memoise::memoise(load_app_data_impl)
