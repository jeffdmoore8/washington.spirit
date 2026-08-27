#' Plain-English glossary for every stat shown in the app
#'
#' Keyed by the exact label the user sees (value-box titles, percentile-chart
#' rows, goals-added action names). [stat_definition()] looks a label up;
#' [stat_label()] renders a label with a hoverable info icon.
#'
#' @name fct_glossary
#' @keywords internal
#' @importFrom htmltools tags tagList
NULL

#' @noRd
stat_glossary <- c(
	# --- headline / value-box stats -----------------------------------------
	"Minutes" =
		"Total minutes this player was on the pitch in league matches this season.",
	"Goals Added (season)" =
		paste(
			"Goals Added (g+): the total goal value the player created or prevented",
			"through their on-ball actions this season, compared with a",
			"replacement-level player. Around 0 is replacement level; higher is better."
		),
	"Goals − xG" =
		paste(
			"Goals scored minus expected goals (xG). Positive means the player",
			"finished their chances better than an average player would have;",
			"negative means worse."
		),
	"xG + xA" =
		paste(
			"Expected goals plus expected assists — the combined quality of the",
			"chances this player took and the chances they set up, regardless of",
			"whether they were actually scored."
		),
	"Goals prevented vs. xG" =
		paste(
			"For goalkeepers: expected goals faced minus goals actually conceded.",
			"Positive means the keeper stopped more than an average keeper would",
			"have, given the shots they faced."
		),
	"Save %" =
		"Share of shots on target that the goalkeeper saved.",

	# --- percentile-chart metrics ------------------------------------------
	"xG per 90" =
		paste(
			"Expected goals per 90 minutes — the quality of chances the player",
			"gets on the ball, scaled to a full match. Measures shot volume and",
			"shot location, not finishing."
		),
	"xA per 90" =
		paste(
			"Expected assists per 90 minutes — the quality of the chances the",
			"player creates for team-mates, scaled to a full match."
		),
	"xG+xA per 90" =
		"Expected goals and expected assists combined, per 90 minutes.",
	"Shots per 90" =
		"Shots attempted per 90 minutes.",
	"Key passes per 90" =
		"Passes that led directly to a team-mate's shot, per 90 minutes.",
	"Goals per 90" =
		"Goals scored per 90 minutes.",
	"Finishing (G − xG)" =
		paste(
			"Goals minus expected goals. A measure of finishing: positive means",
			"the player out-scores the quality of their chances."
		),
	"Passing vs. expected (per 100)" =
		paste(
			"Completed passes above what an average player would complete from the",
			"same positions, per 100 passes attempted. Rewards players who complete",
			"harder passes."
		),
	"Share of team touches" =
		paste(
			"The percentage of the team's total touches that this player has while",
			"on the pitch — how involved they are in the team's play."
		),

	# --- goals-added action types: outfield --------------------------------
	"Dribbling" =
		"Goal value added by carrying the ball past opponents and into more dangerous areas.",
	"Fouling" =
		"Goal value added or lost through committing and drawing fouls.",
	"Interrupting" =
		"Goal value added by defensive actions — tackles, interceptions and blocks that end opponent attacks.",
	"Passing" =
		"Goal value added by moving the ball to team-mates, accounting for how much each pass improved the team's position.",
	"Receiving" =
		"Goal value added by getting into dangerous positions to receive the ball.",
	"Shooting" =
		"Goal value added by taking shots, based on their location and outcome.",

	# --- goals-added action types: goalkeeper ------------------------------
	"Claiming" =
		"Goal value added by catching or punching crosses and loose balls in the box.",
	"Fielding" =
		"Goal value added by gathering routine balls cleanly and keeping possession.",
	"Handling" =
		"Goal value added or lost through holding shots versus parrying them into danger.",
	"Shotstopping" =
		"Goal value added by saving shots, compared with what an average keeper would stop.",
	"Sweeping" =
		"Goal value added by coming off the line to clear balls behind the defence."
)

#' Definition for one stat label, or `NULL` if unknown
#'
#' @param label Character scalar matching a `stat_glossary` key.
#' @noRd
stat_definition <- function(label) {
	if (length(label) != 1 || !label %in% names(stat_glossary)) {
		return(NULL)
	}
	unname(stat_glossary[[label]])
}

#' A hoverable info icon carrying `text`
#'
#' @param text Tooltip body.
#' @param label Accessible label for the icon.
#' @param size Icon size (any CSS length).
#' @noRd
info_icon <- function(text, label = "More information", size = "0.85em") {
	bslib::tooltip(
		htmltools::tags$span(
			class = "spirit-info",
			`aria-label` = label,
			bsicons::bs_icon("info-circle", size = size)
		),
		text,
		placement = "top"
	)
}

#' A stat label followed by a hoverable info icon carrying its definition
#'
#' Used for value-box titles and card headers. Falls back to the bare label when
#' the stat is not in the glossary.
#'
#' @param label Character scalar; also the glossary key.
#' @param text Optional explicit tooltip body; defaults to the glossary entry.
#' @param icon_size Info-icon size (any CSS length).
#' @noRd
stat_label <- function(label, text = stat_definition(label), icon_size = "0.85em") {
	if (is.null(text)) {
		return(label)
	}
	htmltools::tagList(
		label,
		info_icon(text, label = paste0(label, " definition"), size = icon_size)
	)
}
