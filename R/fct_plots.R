#' Plot helpers for the player explorer
#'
#' Each takes a frame produced by the `fct_player` helpers and returns an
#' interactive `ggiraph` object. Hovering a bar shows a plain-English
#' explanation of the stat (from [stat_glossary]) plus the player's value.
#' Colours use the Washington Spirit palette (see [spirit_palette]).
#'
#' @name fct_plots
#' @keywords internal
#' @importFrom ggplot2 ggplot aes geom_hline coord_flip labs scale_fill_manual
#'   scale_y_continuous theme_minimal theme element_blank element_text expansion
#'   margin rel
#' @importFrom rlang .data
NULL

#' Washington Spirit brand palette
#'
#' Deep teal with a high-voltage yellow accent. Yellow has almost no contrast on
#' white, so on light surfaces (cards, charts) teal does the work and yellow is
#' reserved for the dark UI chrome and small highlights.
#'
#' @format A named character vector of hex codes.
#' @noRd
spirit_palette <- c(
	teal       = "#003A40",
	teal_dark  = "#00272B",
	teal_light = "#0A5A62",
	yellow     = "#F3FB00",
	rose       = "#BC4749", # functional "below average" accent
	slate      = "#8FA3A4",
	chalk      = "#F4F6F5",
	white      = "#FFFFFF"
)

SPIRIT_TEAL <- unname(spirit_palette["teal"])
SPIRIT_YELLOW <- unname(spirit_palette["yellow"])
SPIRIT_ROSE <- unname(spirit_palette["rose"])
SPIRIT_SLATE <- unname(spirit_palette["slate"])

#' Wrap a ggplot as a responsive girafe with a branded tooltip
#'
#' The SVG is emitted at its natural size (`rescale = FALSE`); `custom.css` then
#' makes it `width: 100%; height: auto`, so it scales fluidly with the card and
#' its text scales with it. `width_svg`/`height_svg` set the aspect ratio and,
#' inversely, the on-screen text size — smaller `width_svg` = larger text.
#'
#' @param gg A ggplot built with `ggiraph::geom_*_interactive` layers.
#' @param width_svg,height_svg SVG dimensions in inches.
#' @noRd
spirit_girafe <- function(gg, width_svg = 7, height_svg = 4.6) {
	ggiraph::girafe(
		ggobj = gg,
		width_svg = width_svg,
		height_svg = height_svg,
		options = list(
			ggiraph::opts_sizing(rescale = FALSE),
			ggiraph::opts_tooltip(
				css = paste(
					"background-color:#00272B;color:#fff;padding:8px 10px;",
					"border-left:3px solid #F3FB00;border-radius:4px;",
					"font-size:13px;max-width:280px;line-height:1.35;"
				),
				opacity = 0.98
			),
			ggiraph::opts_hover(css = "fill-opacity:0.82;"),
			ggiraph::opts_toolbar(
			  saveaspng = FALSE,
			  hidden = c("lasso_select", "lasso_deselect")
			  )
		)
	)
}

#' Shared minimal theme for the explorer charts
#'
#' Larger base text and tight margins so the plot area dominates the card.
#'
#' @noRd
spirit_theme <- function() {
	ggplot2::theme_minimal(base_size = 13) +
		ggplot2::theme(
			panel.grid.major.y = ggplot2::element_blank(),
			panel.grid.minor = ggplot2::element_blank(),
			axis.title = ggplot2::element_text(size = ggplot2::rel(0.9)),
			axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 6)),
			plot.margin = ggplot2::margin(8, 18, 12, 6)
		)
}

#' Build a tooltip string: bold stat name, definition, then the player's value
#'
#' @param name Stat label (also the [stat_glossary] key).
#' @param value_line Pre-formatted line describing this player's value.
#' @noRd
stat_tooltip <- function(name, value_line) {
	def <- stat_definition(name)
	paste0(
		"<b>", htmltools::htmlEscape(name), "</b>",
		if (!is.null(def)) paste0("<br>", htmltools::htmlEscape(def)),
		"<br><br>", value_line
	)
}

#' Diverging bar of goals added by action type
#'
#' @param acts Output of `player_gplus_actions()` / `gk_gplus_actions()`.
#' @noRd
plot_gplus_actions <- function(acts) {
	acts$action_type <- factor(acts$action_type, levels = acts$action_type)
	acts$positive <- acts$goals_added_above_avg >= 0
	acts$tip <- mapply(
		function(a, v) {
			stat_tooltip(a, sprintf("<b>%+.2f</b> goals vs. league average", v))
		},
		as.character(acts$action_type),
		acts$goals_added_above_avg
	)

	gg <- ggplot2::ggplot(
		acts,
		ggplot2::aes(
			x = .data$action_type,
			y = .data$goals_added_above_avg,
			fill = .data$positive
		)
	) +
		ggplot2::geom_hline(yintercept = 0, colour = "grey40") +
		ggiraph::geom_col_interactive(
			ggplot2::aes(tooltip = .data$tip, data_id = .data$action_type),
			width = 0.7
		) +
		ggplot2::coord_flip() +
		ggplot2::scale_fill_manual(
			values = c("TRUE" = SPIRIT_TEAL, "FALSE" = SPIRIT_ROSE),
			guide = "none"
		) +
		ggplot2::labs(x = NULL, y = "Goals added above league average") +
		spirit_theme()

	spirit_girafe(gg)
}

#' Horizontal percentile bars (0-100)
#'
#' @param pct Output of `player_percentiles()`.
#' @noRd
plot_percentiles <- function(pct) {
	pct <- pct[!is.na(pct$percentile), , drop = FALSE]
	pct <- pct[order(pct$percentile), , drop = FALSE]
	pct$metric <- factor(pct$metric, levels = pct$metric)
	pct$tip <- mapply(
		function(m, v, p) {
			stat_tooltip(
				m,
				sprintf(
					"This player: <b>%s</b><br>%s percentile among peers",
					signif(v, 3),
					ordinal_suffix(round(p))
				)
			)
		},
		as.character(pct$metric), pct$value, pct$percentile
	)

	gg <- ggplot2::ggplot(
		pct,
		ggplot2::aes(x = .data$metric, y = .data$percentile)
	) +
		ggplot2::geom_hline(yintercept = 50, linetype = "dashed", colour = "grey50") +
		ggiraph::geom_col_interactive(
			ggplot2::aes(tooltip = .data$tip, data_id = .data$metric),
			fill = SPIRIT_TEAL,
			width = 0.7
		) +
		ggiraph::geom_text_interactive(
			ggplot2::aes(label = round(.data$percentile)),
			hjust = -0.2,
			size = 3.6
		) +
		ggplot2::coord_flip() +
		ggplot2::scale_y_continuous(
			limits = c(0, 100),
			expand = ggplot2::expansion(mult = c(0, 0.08))
		) +
		ggplot2::labs(x = NULL, y = "Percentile vs. positional peers") +
		spirit_theme()

	spirit_girafe(gg)
}

#' Per-game goals-added with a rolling mean
#'
#' @param form Output of `player_form()`.
#' @noRd
plot_form <- function(form) {
	roll_n <- attr(form, "roll")
	form$tip <- sprintf(
		"Game %d<br><b>%+.2f</b> goals added", form$game_no, form$gplus
	)

	gg <- ggplot2::ggplot(
		form,
		ggplot2::aes(x = .data$game_no, y = .data$gplus)
	) +
		ggplot2::geom_hline(yintercept = 0, colour = "grey60") +
		ggiraph::geom_col_interactive(
			ggplot2::aes(tooltip = .data$tip, data_id = .data$game_no),
			fill = "grey80",
			width = 0.7
		) +
		ggplot2::labs(x = "Game (chronological)", y = "Goals added") +
		spirit_theme()

	if ("gplus_roll" %in% names(form) && any(!is.na(form$gplus_roll))) {
		roll_label <- if (is.null(roll_n)) "Rolling average" else sprintf("%d-game average", roll_n)
		gg <- gg +
			ggplot2::geom_line(
				ggplot2::aes(y = .data$gplus_roll),
				colour = SPIRIT_TEAL,
				linewidth = 1.1,
				na.rm = TRUE
			) +
			ggiraph::geom_point_interactive(
				ggplot2::aes(
					y = .data$gplus_roll,
					tooltip = sprintf("%s: <b>%+.2f</b>", roll_label, .data$gplus_roll)
				),
				colour = SPIRIT_TEAL,
				size = 1.8,
				na.rm = TRUE
			)
	}

	spirit_girafe(gg, width_svg = 8, height_svg = 2.6)
}

#' Ordinal suffix for a whole number (1 -> "1st", 22 -> "22nd")
#'
#' @param n Integer vector.
#' @noRd
ordinal_suffix <- function(n) {
	n <- round(n)
	suff <- rep("th", length(n))
	ones <- n %% 10
	tens <- n %% 100
	suff[ones == 1 & tens != 11] <- "st"
	suff[ones == 2 & tens != 12] <- "nd"
	suff[ones == 3 & tens != 13] <- "rd"
	paste0(n, suff)
}
