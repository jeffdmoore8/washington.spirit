
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{washington.spirit}`

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/jeffdmoore8/washington.spirit/graph/badge.svg)](https://app.codecov.io/gh/jeffdmoore8/washington.spirit)
<!-- badges: end -->

## Installation

You can install the development version of `{washington.spirit}` like
so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
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
#> [1] "2026-08-27 19:43:21 EDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ── R CMD check results ─────────────────────── washington.spirit 0.0.0.9000 ────
#> Duration: 22.9s
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
#> ❯ checking for hidden files and directories ... NOTE
#>   Found the following hidden files and directories:
#>     .github
#>   These were most likely included in error. See section ‘Package
#>   structure’ in the ‘Writing R Extensions’ manual.
#> 
#> ❯ checking top-level files ... NOTE
#>   Non-standard file/directory found at top level:
#>     ‘CLAUDE.md’
#> 
#> ❯ checking package subdirectories ... NOTE
#>   Problems with news in ‘NEWS.md’:
#>   No news entries found.
#> 
#> ❯ checking dependencies in R code ... NOTE
#>   Namespaces in Imports field not imported from:
#>     ‘cachem’ ‘memoise’
#>     All declared Imports should be used.
#> 
#> 0 errors ✔ | 1 warning ✖ | 4 notes ✖
#> Error:
#> ! R CMD check found WARNINGs
```

``` r
covr::package_coverage()
#> Error:
#> ! Failure in `/private/var/folders/mb/8w5tntsn7xx2d369gskqfx4m0000gn/T/Rtmp8xi2gE/R_LIBS5668161dbf8d/washington.spirit/washington.spirit-tests/testthat.Rout.fail`
#> 
#> [ FAIL 0 | WARN 0 | SKIP 1 | PASS 76 ]
#> 
#> ══ Skipped tests (1) ═══════════════════════════════════════════════════════════
#> • On CRAN (1): 'test-golem-recommended.R:71:2'
#> 
#> [ FAIL 0 | WARN 0 | SKIP 1 | PASS 76 ]
#> > 
#> 
#>  *** caught segfault ***
#> address 0x0, cause 'invalid permissions'
#> 
#> Traceback:
#>  1: saveRDS(.counters, file = tmp_file)
#>  2: covr:::save_trace(Sys.getenv("COVERAGE_DIR", "/private/var/folders/mb/8w5tntsn7xx2d369gskqfx4m0000gn/T/Rtmp8xi2gE/R_LIBS5668161dbf8d"))
#>  3: (function (...) {    covr:::save_trace(Sys.getenv("COVERAGE_DIR", "/private/var/folders/mb/8w5tntsn7xx2d369gskqfx4m0000gn/T/Rtmp8xi2gE/R_LIBS5668161dbf8d"))})(<environment>)
#> An irrecoverable exception occurred. R is aborting now ...
```
