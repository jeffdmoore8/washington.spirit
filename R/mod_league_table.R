#' league_table UI Function
#'
#' @description The current NWSL standings, pulled live from ESPN. This is the
#' only part of the app that touches the network at runtime; American Soccer
#' Analysis does not publish standings.
#'
#' @param id Internal parameter for {shiny}.
#' @noRd
mod_league_table_ui <- function(id) {
	ns <- NS(id)
	bslib::card(
		bslib::card_header("NWSL standings"),
		shiny::uiOutput(ns("status")),
		reactable::reactableOutput(ns("table"))
	)
}

#' league_table Server Functions
#'
#' @param id Module id.
#' @noRd
mod_league_table_server <- function(id) {
	shiny::moduleServer(id, function(input, output, session) {
		standings <- shiny::reactive({
			fetch_nwsl_standings()
		})

		output$status <- shiny::renderUI({
			st <- standings()
			if (is.null(st) || !nrow(st)) {
				shiny::div(
					class = "text-muted",
					"Live standings are unavailable right now. Try again shortly."
				)
			} else {
				shiny::div(
					class = "text-muted small",
					sprintf("Live from ESPN · %s season", attr(st, "season"))
				)
			}
		})

		output$table <- reactable::renderReactable({
			st <- standings()
			shiny::validate(shiny::need(!is.null(st) && nrow(st) > 0, "No data."))
			reactable::reactable(
				st,
				defaultSorted = list(rank = "asc"),
				highlight = TRUE,
				compact = TRUE,
				defaultPageSize = nrow(st),
				rowStyle = function(index) {
					if (isTRUE(st$is_spirit[index])) {
						list(
							fontWeight = "bold",
							background = "rgba(243,251,0,0.18)",
							boxShadow = "inset 3px 0 0 #003A40"
						)
					}
				},
				columns = list(
					is_spirit = reactable::colDef(show = FALSE),
					team_id = reactable::colDef(show = FALSE),
					rank = reactable::colDef(name = "#", width = 45),
					team = reactable::colDef(name = "Club", minWidth = 160),
					gamesplayed = reactable::colDef(name = "GP", width = 55),
					wins = reactable::colDef(name = "W", width = 50),
					ties = reactable::colDef(name = "D", width = 50),
					losses = reactable::colDef(name = "L", width = 50),
					pointsfor = reactable::colDef(name = "GF", width = 55),
					pointsagainst = reactable::colDef(name = "GA", width = 55),
					pointdifferential = reactable::colDef(name = "GD", width = 55),
					points = reactable::colDef(name = "Pts", width = 60)
				)
			)
		})
	})
}

#' Fetch and tidy the current NWSL standings from ESPN
#'
#' Memoised for 30 minutes so repeat viewers do not each hit ESPN. Returns
#' `NULL` on any failure so the module can show a friendly message rather than
#' erroring.
#'
#' @return Data frame of standings with an `is_spirit` flag and a `season`
#' attribute, or `NULL`.
#' @noRd
fetch_nwsl_standings_impl <- function(year = as.integer(format(Sys.Date(), "%Y"))) {
	st <- tryCatch(
		usfootballR::espn_nwsl_standings(year = year),
		error = function(e) NULL
	)
	if (is.null(st) || !nrow(st)) {
		return(NULL)
	}
	st <- as.data.frame(st)

	keep <- intersect(
		c(
			"rank", "team", "team_id", "gamesplayed", "wins", "ties", "losses",
			"pointsfor", "pointsagainst", "pointdifferential", "points"
		),
		names(st)
	)
	st <- st[keep]
	num <- setdiff(keep, c("team", "team_id"))
	st[num] <- lapply(st[num], function(x) suppressWarnings(as.numeric(x)))
	st <- st[order(st$rank), , drop = FALSE]
	st$is_spirit <- st$team_id == SPIRIT_ESPN_TEAM_ID
	rownames(st) <- NULL
	attr(st, "season") <- year
	st
}

#' @noRd
fetch_nwsl_standings <- memoise::memoise(
	fetch_nwsl_standings_impl,
	cache = cachem::cache_mem(max_age = 30 * 60)
)
