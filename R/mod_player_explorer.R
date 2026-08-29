#' player_explorer UI Function
#'
#' @description A shiny Module. Lets a fan pick a Washington Spirit player and
#' season and see their goals-added profile, positional percentile ranks, and
#' per-game form. Every stat carries a hover tooltip with a plain-English
#' explanation (see [stat_glossary]).
#'
#' @param id Internal parameter for {shiny}.
#'
#' @importFrom shiny NS tagList
#' @importFrom bslib layout_sidebar sidebar layout_columns card card_header
#' @noRd
mod_player_explorer_ui <- function(id) {
	ns <- NS(id)
	bslib::layout_sidebar(
		sidebar = bslib::sidebar(
			title = "Choose a player",
			shiny::selectInput(ns("season"), "Season", choices = NULL),
			shiny::selectInput(ns("player"), "Player", choices = NULL),
			shiny::helpText(
				"Metrics from American Soccer Analysis. Hover the ",
				bsicons::bs_icon("info-circle", size = "0.85em"),
				" icons or any chart bar for a plain-English explanation."
			)
		),
		shiny::uiOutput(ns("profile")),
		shiny::uiOutput(ns("value_boxes")),
		bslib::layout_columns(
			# Stack the two charts full-width until the viewport is genuinely wide,
			# so bars and labels stay readable on laptops and split screens.
			col_widths = bslib::breakpoints(sm = 12, xl = 6),
			fill = FALSE,
			bslib::card(
				fill = FALSE,
				bslib::card_header(shiny::uiOutput(ns("actions_header"), inline = TRUE)),
				ggiraph::girafeOutput(ns("actions_plot"))
			),
			bslib::card(
				fill = FALSE,
				bslib::card_header(
					"Percentile rank vs. NWSL players at the same position",
					info_icon(paste(
						"Where this player ranks against every NWSL player at the same",
						"position with enough minutes this season. 50 is average; 99 is",
						"near the top of the league. Hover a bar for that stat's meaning."
					))
				),
				ggiraph::girafeOutput(ns("pct_plot"))
			)
		),
		bslib::card(
			fill = FALSE,
			bslib::card_header(
				"Per-game form - goals added",
				info_icon(paste(
					"Goals Added (g+) in each league match this season (bars), with a",
					"rolling average (line) to show form. Hover a bar for that game."
				))
			),
			ggiraph::girafeOutput(ns("form_plot"))
		)
	)
}

#' player_explorer Server Functions
#'
#' @param id Module id.
#' @param app_data Result of [load_app_data()] (a plain list; not reactive).
#'
#' @noRd
mod_player_explorer_server <- function(id, app_data) {
	shiny::moduleServer(id, function(input, output, session) {
		seasons <- spirit_seasons(app_data)

		shiny::updateSelectInput(
			session,
			"season",
			choices = seasons,
			selected = if (length(seasons)) seasons[1] else NULL
		)

		roster <- shiny::reactive({
			shiny::req(input$season)
			spirit_roster(app_data, as.integer(input$season))
		})

		shiny::observeEvent(roster(), {
			r <- roster() # ordered by minutes played, descending
			# Open on the outfield player with the most minutes - a more useful
			# first view than whichever keeper sorts to the top.
			outfield <- r$player_id[r$general_position != "GK"]
			selected <- if (length(outfield)) outfield[1] else r$player_id[1]
			# ...but list the players alphabetically in the dropdown.
			r <- r[order(r$player_name), , drop = FALSE]
			choices <- stats::setNames(r$player_id, r$player_name)
			shiny::updateSelectInput(session, "player", choices = choices, selected = selected)
		})

		sel <- shiny::reactive({
			shiny::req(input$player, input$season)
			list(id = input$player, season = as.integer(input$season))
		})

		season_row <- shiny::reactive({
			player_season_xgoals(app_data, sel()$id, sel()$season)
		})

		is_gk <- shiny::reactive(player_is_gk(app_data, sel()$id, sel()$season))

		player_name <- shiny::reactive({
			r <- roster()
			nm <- r$player_name[r$player_id == sel()$id]
			if (length(nm)) nm[1] else sel()$id
		})

		output$profile <- shiny::renderUI({
			shiny::req(input$player)
			headshot <- player_headshot(app_data, sel()$id)
			badge <- player_badge(app_data, sel()$id)
			meta <- paste(
				c(
					badge,
					paste("Washington Spirit -", sel()$season)
				),
				collapse = "  -  "
			)

			img <- if (is.null(headshot)) {
				NULL
			} else {
				shiny::tags$img(
					src = headshot,
					class = "spirit-headshot",
					alt = player_name(),
					onerror = "this.style.display='none'"
				)
			}

			shiny::div(
				class = "spirit-player-header",
				img,
				shiny::div(
					shiny::p(class = "spirit-player-name", player_name()),
					shiny::div(class = "spirit-player-meta", meta)
				)
			)
		})

		fmt <- function(x, digits = 2) {
			if (length(x) == 0 || is.na(x)) "-" else formatC(x, format = "f", digits = digits)
		}

		gk_season_row <- shiny::reactive({
			gk <- app_data$gk_xgoals_season
			if (is.null(gk)) {
				return(data.frame())
			}
			gk[gk$player_id == sel()$id & gk$season == sel()$season, , drop = FALSE]
		})

		gplus_total <- shiny::reactive({
			acts <- if (is_gk()) {
				gk_gplus_actions(app_data, sel()$id, sel()$season)
			} else {
				player_gplus_actions(app_data, sel()$id, sel()$season)
			}
			if (!nrow(acts)) NA_real_ else sum(acts$goals_added_raw, na.rm = TRUE)
		})

		output$value_boxes <- shiny::renderUI({
			row <- season_row()
			minutes <- if (nrow(row)) format(round(row$minutes_played[1]), big.mark = ",") else "-"

			boxes <- if (is_gk()) {
				g <- gk_season_row()
				save_pct <- if (nrow(g) && !is.na(g$shots_faced[1]) && g$shots_faced[1] > 0) {
					paste0(round(100 * g$saves[1] / g$shots_faced[1]), "%")
				} else {
					"-"
				}
				prevented <- if (nrow(g)) fmt(-g$goals_minus_xgoals_gk[1]) else "-"
				list(
					c("Minutes", minutes),
					c("Goals Added (season)", fmt(gplus_total())),
					c("Goals prevented vs. xG", prevented),
					c("Save %", save_pct)
				)
			} else {
				list(
					c("Minutes", minutes),
					c("Goals Added (season)", fmt(gplus_total())),
					c("Goals - xG", if (nrow(row)) fmt(row$goals_minus_xgoals[1]) else "-"),
					c("xG + xA", if (nrow(row)) fmt(row$xgoals_plus_xassists[1]) else "-")
				)
			}

			tiles <- lapply(boxes, function(b) {
				shiny::div(
					class = "spirit-stat",
					shiny::div(class = "spirit-stat-value", b[2]),
					shiny::div(
						class = "spirit-stat-label",
						stat_label(b[1], icon_size = "1.2em")
					)
				)
			})
			do.call(bslib::layout_columns, c(list(fill = FALSE), tiles))
		})

		output$actions_header <- shiny::renderUI({
			title <- if (is_gk()) {
				"What they do well - goalkeeper goals added by action"
			} else {
				"What they do well - goals added by action"
			}
			shiny::tagList(
				title,
				info_icon(paste(
					"Goals Added (g+) split by phase of play, shown as the goal value",
					"added above or below an average NWSL player at this position.",
					"Hover a bar for what that action covers."
				))
			)
		})

		output$actions_plot <- ggiraph::renderGirafe({
			acts <- if (is_gk()) {
				gk_gplus_actions(app_data, sel()$id, sel()$season)
			} else {
				player_gplus_actions(app_data, sel()$id, sel()$season)
			}
			shiny::validate(shiny::need(nrow(acts) > 0, "No goals-added data for this selection."))
			plot_gplus_actions(acts)
		})

		output$pct_plot <- ggiraph::renderGirafe({
			shiny::validate(shiny::need(!is_gk(), "Percentile view is for outfield players."))
			pct <- player_percentiles(app_data, sel()$id, sel()$season)
			shiny::validate(shiny::need(
				nrow(pct) > 0 && any(!is.na(pct$percentile)),
				"Not enough minutes for a percentile comparison this season."
			))
			plot_percentiles(pct)
		})

		output$form_plot <- ggiraph::renderGirafe({
			form <- player_form(app_data, sel()$id, sel()$season)
			shiny::validate(shiny::need(nrow(form) > 0, "No per-game data for this selection."))
			plot_form(form)
		})
	})
}
