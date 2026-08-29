
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
#> [1] "2026-08-29 17:19:00 EDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ── R CMD check results ─────────────────────── washington.spirit 0.0.0.9000 ────
#> Duration: 22.1s
#> 
#> ❯ checking code files for non-ASCII characters ... WARNING
#>   Found the following files with non-ASCII characters:
#>     R/app_server.R
#>     R/fct_glossary.R
#>     R/fct_player.R
#>     R/fct_roster.R
#>     R/mod_league_table.R
#>     R/mod_player_explorer.R
#>   Portable packages must use only ASCII characters in their R code and
#>   NAMESPACE directives, except perhaps in comments.
#>   Use \uxxxx escapes for other characters.
#>   Function ‘tools::showNonASCIIfile’ can help in finding non-ASCII
#>   characters in files.
#> 
#> ❯ checking top-level files ... NOTE
#>   Non-standard files/directories found at top level:
#>     ‘CLAUDE.md’ ‘manifest.json’
#> 
#> ❯ checking package subdirectories ... NOTE
#>   Problems with news in ‘NEWS.md’:
#>   No news entries found.
#> 
#> ❯ checking dependencies in R code ... NOTE
#>   Namespaces in Imports field not imported from:
#>     ‘cachem’ ‘memoise’ ‘pkgload’
#>     All declared Imports should be used.
#> 
#> 0 errors ✔ | 1 warning ✖ | 3 notes ✖
#> Error:
#> ! R CMD check found WARNINGs
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
