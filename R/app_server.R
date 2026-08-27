#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
	# Read the pre-cached ASA snapshots once (memoised across the process).
	app_data <- load_app_data()

	output$data_stamp <- renderText({
		meta <- app_data$meta
		if (is.null(meta) || !nrow(meta)) {
			return("")
		}
		paste("Data through", meta$seasons_to[1], "· refreshed", meta$refreshed_at[1])
	})

	mod_player_explorer_server("player_explorer_1", app_data)
	mod_league_table_server("league_table_1")
}
