test_that("normalize_name transliterates accents and strips punctuation", {
	expect_equal(normalize_name("Élisabeth Tsé"), "elisabeth tse")
	expect_equal(normalize_name("Emma Gaines-Ramos"), "emma gaines ramos")
	expect_equal(normalize_name("  Trinity   Rodman "), "trinity rodman")
	expect_equal(normalize_name("Claudia Martínez"), "claudia martinez")
})

test_that("player_headshot and player_badge read the roster slot", {
	d <- list(roster = data.frame(
		player_id = c("p1", "p2"),
		jersey = c(9L, NA_integer_),
		position = c("F", ""),
		headshot_url = c("https://example.test/p1.png", NA_character_),
		stringsAsFactors = FALSE
	))
	expect_equal(player_headshot(d, "p1"), "https://example.test/p1.png")
	expect_null(player_headshot(d, "p2"))
	expect_null(player_headshot(d, "nope"))
	expect_equal(player_badge(d, "p1"), "#9 · F")
	expect_null(player_badge(d, "p2"))
})

test_that("headshot helpers tolerate a missing roster slot", {
	expect_null(player_headshot(list(), "p1"))
	expect_null(player_badge(list(), "p1"))
})
