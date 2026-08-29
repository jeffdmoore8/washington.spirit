#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
	tagList(
		golem_add_external_resources(),
		bslib::page_navbar(
			title = "Washington Spirit Analytics",
			theme = bslib::bs_theme(
				version = 5,
				bg = "#FFFFFF",
				fg = "#00272B",
				primary = "#003A40",
				secondary = "#F3FB00",
				"border-radius" = "0.4rem",
				base_font = bslib::font_google("Barlow", local = FALSE),
				heading_font = bslib::font_google("Barlow Condensed", local = FALSE)
			),
			bslib::nav_panel(
				"Player explorer",
				mod_player_explorer_ui("player_explorer_1")
			),
			bslib::nav_panel(
				"League table",
				mod_league_table_ui("league_table_1")
			),
			bslib::nav_spacer(),
			bslib::nav_item(
				shiny::tags$span(
					class = "navbar-text small",
					textOutput("data_stamp", inline = TRUE)
				)
			)
		)
	)
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
	add_resource_path(
		"www",
		app_sys("app/www")
	)

	tags$head(
		favicon(ext = 'png'),
		bundle_resources(
			path = app_sys("app/www"),
			app_title = "washington.spirit"
		)
		# Add here other external resources
		# for example, you can add shinyalert::useShinyalert()
	)
}
