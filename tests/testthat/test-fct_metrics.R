test_that("pct_rank spans 0-100 with the median near 50", {
	x <- 1:99
	p <- pct_rank(x)
	expect_equal(p[50], 50, tolerance = 1)
	expect_true(all(p > 0 & p < 100))
	expect_true(which.max(p) == length(x))
})

test_that("pct_rank keeps NAs and ignores them in the population", {
	p <- pct_rank(c(10, NA, 20, 30))
	expect_true(is.na(p[2]))
	expect_equal(sum(!is.na(p)), 3)
})

test_that("pct_rank handles degenerate inputs", {
	expect_true(all(is.na(pct_rank(c(NA, NA)))))
	expect_equal(pct_rank(5), 50)
})

test_that("per90 scales by minutes and floors small samples", {
	expect_equal(per90(5, 900, min_minutes = 180), 0.5)
	expect_true(is.na(per90(1, 90, min_minutes = 180)))
})

test_that("add_positional_percentiles ranks within group and respects the floor", {
	df <- data.frame(
		general_position = rep(c("ST", "CB"), each = 4),
		minutes_played = c(1000, 1000, 1000, 100, 1000, 1000, 1000, 1000),
		xg = c(1, 2, 3, 99, 5, 6, 7, 8)
	)
	out <- add_positional_percentiles(df, "xg", min_minutes = 450)
	expect_true("xg_pct" %in% names(out))
	# row 4 is below the minutes floor -> NA percentile, and excluded from the
	# ST population so the huge xg does not distort rows 1-3.
	expect_true(is.na(out$xg_pct[4]))
	expect_lt(out$xg_pct[1], out$xg_pct[3])
	# CB group ranked independently
	expect_equal(which.max(out$xg_pct[5:8]), 4)
})
