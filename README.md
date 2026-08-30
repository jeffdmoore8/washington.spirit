
<!-- README.md is generated from README.Rmd. Please edit that file -->

# washington.spirit <a><img src="inst/app/www/logo.png" align="right" width="120" height="100%" alt="" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/jeffdmoore8/washington.spirit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jeffdmoore8/washington.spirit/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/jeffdmoore8/washington.spirit/graph/badge.svg)](https://app.codecov.io/gh/jeffdmoore8/washington.spirit)
<!-- badges: end -->

## Installation

You can install the development version of `washington.spirit` like so:

``` r
# install.packages("pak")
pak::pak("jeffdmoore8/washington.spirit")
```

## Run

You can launch the application by running:

``` r
washington.spirit::run_app()
```

## About

You are reading the doc about version : 0.0.0.9000

This README has been compiled on the

``` r
Sys.time()
#> [1] "2026-08-29 18:01:19 EDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ── R CMD check results ─────────────────────── washington.spirit 0.0.0.9000 ────
#> Duration: 21.9s
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

``` r
covr::package_coverage()
#> washington.spirit Coverage: 55.26%
#> R/fct_asa.R: 0.00%
#> R/run_app.R: 0.00%
#> R/fct_plots.R: 5.41%
#> R/fct_roster.R: 47.27%
#> R/mod_player_explorer.R: 48.04%
#> R/fct_data.R: 61.90%
#> R/fct_metrics.R: 63.33%
#> R/fct_player.R: 81.54%
#> R/app_server.R: 90.00%
#> R/mod_league_table.R: 94.23%
#> R/app_config.R: 100.00%
#> R/app_ui.R: 100.00%
#> R/fct_glossary.R: 100.00%
```
