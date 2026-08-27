test_that("every stat shown in the app has a glossary entry", {
	value_box_stats <- c(
		"Minutes", "Goals Added (season)", "Goals − xG", "xG + xA",
		"Goals prevented vs. xG", "Save %"
	)
	percentile_metrics <- c(
		"xG per 90", "xA per 90", "xG+xA per 90", "Shots per 90",
		"Key passes per 90", "Goals per 90", "Finishing (G − xG)",
		"Passing vs. expected (per 100)", "Share of team touches"
	)
	outfield_actions <- c(
		"Dribbling", "Fouling", "Interrupting", "Passing", "Receiving", "Shooting"
	)
	gk_actions <- c(
		"Claiming", "Fielding", "Handling", "Passing", "Shotstopping", "Sweeping"
	)
	for (s in unique(c(value_box_stats, percentile_metrics, outfield_actions, gk_actions))) {
		expect_false(is.null(stat_definition(s)), info = s)
	}
})

test_that("stat_definition returns NULL for unknown labels", {
	expect_null(stat_definition("Corner flags cleared"))
})

test_that("stat_label degrades to bare text when unknown", {
	expect_identical(stat_label("Nonsense stat"), "Nonsense stat")
	expect_s3_class(stat_label("Minutes"), "shiny.tag.list")
})

test_that("ordinal_suffix handles the tricky cases", {
	expect_equal(ordinal_suffix(c(1, 2, 3, 4, 11, 12, 13, 21, 22, 23, 50)),
		c("1st", "2nd", "3rd", "4th", "11th", "12th", "13th", "21st", "22nd", "23rd", "50th"))
})
