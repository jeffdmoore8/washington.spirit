
<!-- README.md is generated from README.Rmd. Please edit that file -->

# washington.spirit <a>\<img src=“inst/app/www/logo.png align=”right” width=“120” height=“100%” alt=“” /\>

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
#> ℹ Loading metadata database
#> ✔ Loading metadata database ... done
#> 
#> 
#> → Package library at '/private/var/folders/mb/8w5tntsn7xx2d369gskqfx4m0000gn/T/Rtmpu2FTGZ/temp_libpath16a6875244b2'.
#> → Will install 116 packages.
#> → Will update 1 package.
#> → Will download 117 packages with unknown size.
#> + arrow                          25.0.1     🔧 ⬇
#> + askpass                        1.2.1      🔧 ⬇
#> + assertthat                     0.2.1       ⬇
#> + attempt                        0.3.1       ⬇
#> + base64enc                      0.1-6      🔧 ⬇
#> + bit                            4.6.0      🔧 ⬇
#> + bit64                          4.8.4      🔧 ⬇
#> + bsicons                        0.1.2       ⬇
#> + bslib                          0.12.0      ⬇
#> + cachem                         1.1.0      🔧 ⬇
#> + callr                          3.8.0       ⬇
#> + cli                            3.6.6      🔧 ⬇
#> + clipr                          0.8.1       ⬇
#> + commonmark                     2.0.0      🔧 ⬇
#> + config                         0.3.2       ⬇
#> + crayon                         1.5.3       ⬇
#> + credentials                    2.0.3       ⬇
#> + curl                           8.0.0      🔧 ⬇
#> + data.table                     1.18.6.1   🔧 ⬇
#> + desc                           1.4.3       ⬇
#> + digest                         0.6.39     🔧 ⬇
#> + dplyr                          1.2.1      🔧 ⬇
#> + evaluate                       1.0.5       ⬇
#> + farver                         2.1.2      🔧 ⬇
#> + fastmap                        1.2.0      🔧 ⬇
#> + fontawesome                    0.5.3       ⬇
#> + fontBitstreamVera              0.1.1       ⬇
#> + fontLiberation                 0.1.0       ⬇
#> + fontquiver                     0.2.1       ⬇
#> + fs                             2.1.0      🔧 ⬇
#> + furrr                          0.4.0       ⬇
#> + future                         1.75.0      ⬇
#> + gdtools                        0.5.1      🔧 ⬇
#> + generics                       0.1.4       ⬇
#> + gert                           2.4.1      🔧 ⬇
#> + ggiraph                        0.9.6      🔧 ⬇
#> + ggplot2                        4.0.3       ⬇
#> + gh                             1.6.1       ⬇
#> + gitcreds                       0.1.2       ⬇
#> + globals                        0.19.1      ⬇
#> + glue                           1.8.1      🔧 ⬇
#> + golem                          1.0.1       ⬇
#> + gtable                         0.3.6       ⬇
#> + highr                          0.12        ⬇
#> + hms                            1.1.4       ⬇
#> + htmltools                      0.5.9      🔧 ⬇
#> + htmlwidgets                    1.6.4       ⬇
#> + httpuv                         1.6.17     🔧 ⬇
#> + httr                           1.4.8       ⬇
#> + httr2                          1.3.0       ⬇
#> + ini                            0.3.1       ⬇
#> + isoband                        0.3.0      🔧 ⬇
#> + janitor                        2.2.1       ⬇
#> + jquerylib                      0.1.4       ⬇
#> + jsonlite                       2.0.0      🔧 ⬇
#> + knitr                          1.51        ⬇
#> + labeling                       0.4.3       ⬇
#> + later                          1.4.8      🔧 ⬇
#> + lifecycle                      1.0.5       ⬇
#> + listenv                        1.0.0       ⬇
#> + lubridate                      1.9.5      🔧 ⬇
#> + magrittr                       2.0.5      🔧 ⬇
#> + memoise                        2.0.1       ⬇
#> + mime                           0.13       🔧 ⬇
#> + openssl                        2.4.2      🔧 ⬇
#> + otel                           0.2.0       ⬇
#> + parallelly                     1.48.0     🔧 ⬇
#> + pillar                         1.11.1      ⬇
#> + pkgbuild                       1.4.8       ⬇
#> + pkgconfig                      2.0.3       ⬇
#> + pkgload                        1.5.3       ⬇
#> + processx                       3.9.0      🔧 ⬇
#> + progressr                      1.0.0       ⬇
#> + promises                       1.5.0       ⬇
#> + ps                             1.9.3      🔧 ⬇
#> + purrr                          1.2.2      🔧 ⬇
#> + R6                             2.6.1       ⬇
#> + rappdirs                       0.3.4      🔧 ⬇
#> + RColorBrewer                   1.1-3       ⬇
#> + Rcpp                           1.1.2      🔧 ⬇
#> + RcppParallel                   6.2.1      🔧 ⬇
#> + reactable                      0.4.5       ⬇
#> + reactR                         0.6.1       ⬇
#> + rlang                          1.3.0      🔧 ⬇
#> + rmarkdown                      2.31        ⬇
#> + rprojroot                      2.1.1       ⬇
#> + rstudioapi                     0.19.0      ⬇
#> + rvest                          1.0.5       ⬇
#> + S7                             0.2.2      🔧 ⬇
#> + sass                           0.4.10     🔧 ⬇
#> + scales                         1.4.0       ⬇
#> + selectr                        0.6-0       ⬇
#> + shiny                          1.14.0      ⬇
#> + snakecase                      0.11.1      ⬇
#> + sourcetools                    0.1.7-2    🔧 ⬇
#> + stringi                        1.8.9      🔧 ⬇
#> + stringr                        1.6.0       ⬇
#> + sys                            3.4.3      🔧 ⬇
#> + systemfonts                    1.3.2      🔧 ⬇
#> + tibble                         3.3.1      🔧 ⬇
#> + tidyr                          1.3.2      🔧 ⬇
#> + tidyselect                     1.2.1      🔧 ⬇
#> + timechange                     0.4.0      🔧 ⬇
#> + tinytex                        0.60        ⬇
#> + usethis                        3.2.1       ⬇
#> + usfootballR                    0.0.1      👷🏽🔧 ⬇ (GitHub: 1c596de)
#> + utf8                           1.2.6      🔧 ⬇
#> + vctrs                          0.7.3      🔧 ⬇
#> + viridisLite                    0.4.3       ⬇
#> + washington.spirit 0.0.0.9000 → 0.0.0.9000 👷🏽🔧 ⬇ (GitHub: ba2bd31)
#> + whisker                        0.4.1       ⬇
#> + withr                          3.0.3       ⬇
#> + xfun                           0.60       🔧 ⬇
#> + xml2                           1.6.0      🔧 ⬇
#> + xtable                         1.8-8       ⬇
#> + yaml                           2.3.12     🔧 ⬇
#> + zip                            3.0.2      🔧 ⬇
#> ℹ Getting 117 pkgs with unknown sizes
#> ✔ Cached copy of washington.spirit 0.0.0.9000 (source) is the latest build
#> ✔ Cached copy of usfootballR 0.0.1 (source) is the latest build
#> ✔ Got askpass 1.2.1 (aarch64-apple-darwin23) (25.30 kB)
#> ✔ Got assertthat 0.2.1 (aarch64-apple-darwin23) (55.63 kB)
#> ✔ Got base64enc 0.1-6 (aarch64-apple-darwin23) (38.77 kB)
#> ✔ Got attempt 0.3.1 (aarch64-apple-darwin23) (114.19 kB)
#> ✔ Got cachem 1.1.0 (aarch64-apple-darwin23) (78.06 kB)
#> ✔ Got bit 4.6.0 (aarch64-apple-darwin23) (745.22 kB)
#> ✔ Got bsicons 0.1.2 (aarch64-apple-darwin23) (254.63 kB)
#> ✔ Got bit64 4.8.4 (aarch64-apple-darwin23) (657.95 kB)
#> ✔ Got callr 3.8.0 (aarch64-apple-darwin23) (479.08 kB)
#> ✔ Got config 0.3.2 (aarch64-apple-darwin23) (100.35 kB)
#> ✔ Got cli 3.6.6 (aarch64-apple-darwin23) (1.49 MB)
#> ✔ Got desc 1.4.3 (aarch64-apple-darwin23) (339.74 kB)
#> ✔ Cached copy of arrow 25.0.1 (aarch64-apple-darwin23) is the latest build
#> ✔ Got commonmark 2.0.0 (aarch64-apple-darwin23) (141.30 kB)
#> ✔ Got digest 0.6.39 (aarch64-apple-darwin23) (390.07 kB)
#> ✔ Got curl 8.0.0 (aarch64-apple-darwin23) (1.22 MB)
#> ✔ Got evaluate 1.0.5 (aarch64-apple-darwin23) (103.96 kB)
#> ✔ Got fastmap 1.2.0 (aarch64-apple-darwin23) (223.27 kB)
#> ✔ Got dplyr 1.2.1 (aarch64-apple-darwin23) (1.66 MB)
#> ✔ Got fontawesome 0.5.3 (aarch64-apple-darwin23) (1.40 MB)
#> ✔ Got fontBitstreamVera 0.1.1 (aarch64-apple-darwin23) (692.54 kB)
#> ✔ Got farver 2.1.2 (aarch64-apple-darwin23) (1.98 MB)
#> ✔ Got fs 2.1.0 (aarch64-apple-darwin23) (461.14 kB)
#> ✔ Got generics 0.1.4 (aarch64-apple-darwin23) (82.64 kB)
#> ✔ Got fontquiver 0.2.1 (aarch64-apple-darwin23) (2.28 MB)
#> ✔ Got bslib 0.12.0 (aarch64-apple-darwin23) (6.19 MB)
#> ✔ Got glue 1.8.1 (aarch64-apple-darwin23) (182.88 kB)
#> ✔ Got gdtools 0.5.1 (aarch64-apple-darwin23) (1.69 MB)
#> ✔ Got gtable 0.3.6 (aarch64-apple-darwin23) (226.75 kB)
#> ✔ Got highr 0.12 (aarch64-apple-darwin23) (37.91 kB)
#> ✔ Got golem 1.0.1 (aarch64-apple-darwin23) (1.31 MB)
#> ✔ Got htmltools 0.5.9 (aarch64-apple-darwin23) (360.87 kB)
#> ✔ Got htmlwidgets 1.6.4 (aarch64-apple-darwin23) (805.51 kB)
#> ✔ Got ggiraph 0.9.6 (aarch64-apple-darwin23) (3.51 MB)
#> ✔ Got fontLiberation 0.1.0 (aarch64-apple-darwin23) (4.52 MB)
#> ✔ Got httr 1.4.8 (aarch64-apple-darwin23) (481.88 kB)
#> ✔ Got jquerylib 0.1.4 (aarch64-apple-darwin23) (526.99 kB)
#> ✔ Got jsonlite 2.0.0 (aarch64-apple-darwin23) (1.11 MB)
#> ✔ Got isoband 0.3.0 (aarch64-apple-darwin23) (1.98 MB)
#> ✔ Got knitr 1.51 (aarch64-apple-darwin23) (1.06 MB)
#> ✔ Got labeling 0.4.3 (aarch64-apple-darwin23) (61.23 kB)
#> ✔ Got lifecycle 1.0.5 (aarch64-apple-darwin23) (133.80 kB)
#> ✔ Got httpuv 1.6.17 (aarch64-apple-darwin23) (673.15 kB)
#> ✔ Got magrittr 2.0.5 (aarch64-apple-darwin23) (234.92 kB)
#> ✔ Got memoise 2.0.1 (aarch64-apple-darwin23) (51.78 kB)
#> ✔ Got mime 0.13 (aarch64-apple-darwin23) (49.00 kB)
#> ✔ Got later 1.4.8 (aarch64-apple-darwin23) (806.50 kB)
#> ✔ Got otel 0.2.0 (aarch64-apple-darwin23) (282.02 kB)
#> ✔ Got pkgbuild 1.4.8 (aarch64-apple-darwin23) (210.80 kB)
#> ✔ Got pkgconfig 2.0.3 (aarch64-apple-darwin23) (18.45 kB)
#> ✔ Got pillar 1.11.1 (aarch64-apple-darwin23) (661.97 kB)
#> ✔ Got pkgload 1.5.3 (aarch64-apple-darwin23) (225.74 kB)
#> ✔ Got processx 3.9.0 (aarch64-apple-darwin23) (401.11 kB)
#> ✔ Got ps 1.9.3 (aarch64-apple-darwin23) (418.21 kB)
#> ✔ Got purrr 1.2.2 (aarch64-apple-darwin23) (587.80 kB)
#> ✔ Got R6 2.6.1 (aarch64-apple-darwin23) (88.14 kB)
#> ✔ Got rappdirs 0.3.4 (aarch64-apple-darwin23) (50.21 kB)
#> ✔ Got RColorBrewer 1.1-3 (aarch64-apple-darwin23) (51.84 kB)
#> ✔ Got ggplot2 4.0.3 (aarch64-apple-darwin23) (8.47 MB)
#> ✔ Got reactable 0.4.5 (aarch64-apple-darwin23) (1.06 MB)
#> ✔ Got reactR 0.6.1 (aarch64-apple-darwin23) (610.97 kB)
#> ✔ Got openssl 2.4.2 (aarch64-apple-darwin23) (4.05 MB)
#> ✔ Got promises 1.5.0 (aarch64-apple-darwin23) (1.68 MB)
#> ✔ Got rprojroot 2.1.1 (aarch64-apple-darwin23) (114.86 kB)
#> ✔ Got S7 0.2.2 (aarch64-apple-darwin23) (346.79 kB)
#> ✔ Got rlang 1.3.0 (aarch64-apple-darwin23) (1.94 MB)
#> ✔ Got scales 1.4.0 (aarch64-apple-darwin23) (873.09 kB)
#> ✔ Got sourcetools 0.1.7-2 (aarch64-apple-darwin23) (151.97 kB)
#> ✔ Got sys 3.4.3 (aarch64-apple-darwin23) (52.51 kB)
#> ✔ Got Rcpp 1.1.2 (aarch64-apple-darwin23) (3.56 MB)
#> ✔ Got rmarkdown 2.31 (aarch64-apple-darwin23) (2.63 MB)
#> ✔ Got tibble 3.3.1 (aarch64-apple-darwin23) (661.97 kB)
#> ✔ Got tidyselect 1.2.1 (aarch64-apple-darwin23) (226.62 kB)
#> ✔ Got tinytex 0.60 (aarch64-apple-darwin23) (149.93 kB)
#> ✔ Got utf8 1.2.6 (aarch64-apple-darwin23) (216.16 kB)
#> ✔ Cached copy of sass 0.4.10 (aarch64-apple-darwin23) is the latest build
#> ✔ Got shiny 1.14.0 (aarch64-apple-darwin23) (4.56 MB)
#> ✔ Got withr 3.0.3 (aarch64-apple-darwin23) (225.06 kB)
#> ✔ Cached copy of systemfonts 1.3.2 (aarch64-apple-darwin23) is the latest build
#> ✔ Got viridisLite 0.4.3 (aarch64-apple-darwin23) (1.30 MB)
#> ✔ Got yaml 2.3.12 (aarch64-apple-darwin23) (233.52 kB)
#> ✔ Got xfun 0.60 (aarch64-apple-darwin23) (658.29 kB)
#> ✔ Got clipr 0.8.1 (aarch64-apple-darwin23) (55.07 kB)
#> ✔ Got crayon 1.5.3 (aarch64-apple-darwin23) (166.32 kB)
#> ✔ Got xtable 1.8-8 (aarch64-apple-darwin23) (753.44 kB)
#> ✔ Got vctrs 0.7.3 (aarch64-apple-darwin23) (2.67 MB)
#> ✔ Got credentials 2.0.3 (aarch64-apple-darwin23) (219.75 kB)
#> ✔ Got gitcreds 0.1.2 (aarch64-apple-darwin23) (98.39 kB)
#> ✔ Got furrr 0.4.0 (aarch64-apple-darwin23) (1.02 MB)
#> ✔ Got future 1.75.0 (aarch64-apple-darwin23) (1.03 MB)
#> ✔ Got hms 1.1.4 (aarch64-apple-darwin23) (104.17 kB)
#> ✔ Got globals 0.19.1 (aarch64-apple-darwin23) (166.50 kB)
#> ✔ Got ini 0.3.1 (aarch64-apple-darwin23) (13.99 kB)
#> ✔ Got gh 1.6.1 (aarch64-apple-darwin23) (171.97 kB)
#> ✔ Got httr2 1.3.0 (aarch64-apple-darwin23) (987.59 kB)
#> ✔ Got listenv 1.0.0 (aarch64-apple-darwin23) (129.85 kB)
#> ✔ Got janitor 2.2.1 (aarch64-apple-darwin23) (290.39 kB)
#> ✔ Got progressr 1.0.0 (aarch64-apple-darwin23) (574.87 kB)
#> ✔ Got parallelly 1.48.0 (aarch64-apple-darwin23) (646.30 kB)
#> ✔ Got RcppParallel 6.2.1 (aarch64-apple-darwin23) (534.61 kB)
#> ✔ Got rstudioapi 0.19.0 (aarch64-apple-darwin23) (358.20 kB)
#> ✔ Got lubridate 1.9.5 (aarch64-apple-darwin23) (1.00 MB)
#> ✔ Got snakecase 0.11.1 (aarch64-apple-darwin23) (161.04 kB)
#> ✔ Got gert 2.4.1 (aarch64-apple-darwin23) (4.42 MB)
#> ✔ Got rvest 1.0.5 (aarch64-apple-darwin23) (307.19 kB)
#> ✔ Got selectr 0.6-0 (aarch64-apple-darwin23) (591.98 kB)
#> ✔ Got data.table 1.18.6.1 (aarch64-apple-darwin23) (3.48 MB)
#> ✔ Got stringr 1.6.0 (aarch64-apple-darwin23) (338.01 kB)
#> ✔ Got timechange 0.4.0 (aarch64-apple-darwin23) (930.04 kB)
#> ✔ Got whisker 0.4.1 (aarch64-apple-darwin23) (66.21 kB)
#> ✔ Got tidyr 1.3.2 (aarch64-apple-darwin23) (1.33 MB)
#> ✔ Got zip 3.0.2 (aarch64-apple-darwin23) (346.70 kB)
#> ✔ Got usethis 3.2.1 (aarch64-apple-darwin23) (933.12 kB)
#> ✔ Got xml2 1.6.0 (aarch64-apple-darwin23) (1.04 MB)
#> ✔ Cached copy of stringi 1.8.9 (aarch64-apple-darwin23) is the latest build
#> ✔ Installed washington.spirit 0.0.0.9000 (github::jeffdmoore8/washington.spirit@ba2bd31) (112ms)
#> ✔ Installed askpass 1.2.1  (104ms)
#> ✔ Installed assertthat 0.2.1  (110ms)
#> ✔ Installed attempt 0.3.1  (134ms)
#> ✔ Installed base64enc 0.1-6  (137ms)
#> ✔ Installed bit 4.6.0  (138ms)
#> ✔ Installed arrow 25.0.1  (238ms)
#> ✔ Installed bit64 4.8.4  (172ms)
#> ✔ Installed bsicons 0.1.2  (58ms)
#> ✔ Installed cachem 1.1.0  (17ms)
#> ✔ Installed callr 3.8.0  (23ms)
#> ✔ Installed cli 3.6.6  (54ms)
#> ✔ Installed bslib 0.12.0  (206ms)
#> ✔ Installed commonmark 2.0.0  (41ms)
#> ✔ Installed config 0.3.2  (40ms)
#> ✔ Installed curl 8.0.0  (41ms)
#> ✔ Installed desc 1.4.3  (40ms)
#> ✔ Installed digest 0.6.39  (43ms)
#> ✔ Installed dplyr 1.2.1  (47ms)
#> ✔ Installed evaluate 1.0.5  (71ms)
#> ✔ Installed farver 2.1.2  (46ms)
#> ✔ Installed fastmap 1.2.0  (39ms)
#> ✔ Installed fontawesome 0.5.3  (40ms)
#> ✔ Installed fontBitstreamVera 0.1.1  (39ms)
#> ✔ Installed fontLiberation 0.1.0  (39ms)
#> ✔ Installed fontquiver 0.2.1  (39ms)
#> ✔ Installed fs 2.1.0  (40ms)
#> ✔ Installed gdtools 0.5.1  (68ms)
#> ✔ Installed generics 0.1.4  (39ms)
#> ✔ Installed ggiraph 0.9.6  (56ms)
#> ✔ Installed ggplot2 4.0.3  (60ms)
#> ✔ Installed glue 1.8.1  (44ms)
#> ✔ Installed golem 1.0.1  (43ms)
#> ✔ Installed gtable 0.3.6  (40ms)
#> ✔ Installed highr 0.12  (39ms)
#> ✔ Installed htmltools 0.5.9  (67ms)
#> ✔ Installed htmlwidgets 1.6.4  (42ms)
#> ✔ Installed httpuv 1.6.17  (42ms)
#> ✔ Installed httr 1.4.8  (42ms)
#> ✔ Installed isoband 0.3.0  (41ms)
#> ✔ Installed jquerylib 0.1.4  (39ms)
#> ✔ Installed jsonlite 2.0.0  (39ms)
#> ✔ Installed knitr 1.51  (73ms)
#> ✔ Installed labeling 0.4.3  (72ms)
#> ✔ Installed later 1.4.8  (40ms)
#> ✔ Installed lifecycle 1.0.5  (41ms)
#> ✔ Installed magrittr 2.0.5  (40ms)
#> ✔ Installed memoise 2.0.1  (39ms)
#> ✔ Installed mime 0.13  (38ms)
#> ✔ Installed openssl 2.4.2  (42ms)
#> ✔ Installed otel 0.2.0  (69ms)
#> ✔ Installed pillar 1.11.1  (47ms)
#> ✔ Installed pkgbuild 1.4.8  (40ms)
#> ✔ Installed pkgconfig 2.0.3  (38ms)
#> ✔ Installed pkgload 1.5.3  (38ms)
#> ✔ Installed processx 3.9.0  (40ms)
#> ✔ Installed promises 1.5.0  (41ms)
#> ✔ Installed ps 1.9.3  (41ms)
#> ✔ Installed purrr 1.2.2  (84ms)
#> ✔ Installed R6 2.6.1  (42ms)
#> ✔ Installed rappdirs 0.3.4  (40ms)
#> ✔ Installed RColorBrewer 1.1-3  (39ms)
#> ✔ Installed reactable 0.4.5  (25ms)
#> ✔ Installed reactR 0.6.1  (26ms)
#> ✔ Installed Rcpp 1.1.2  (135ms)
#> ✔ Installed rlang 1.3.0  (42ms)
#> ✔ Installed rmarkdown 2.31  (92ms)
#> ✔ Installed rprojroot 2.1.1  (57ms)
#> ✔ Installed S7 0.2.2  (41ms)
#> ✔ Installed sass 0.4.10  (44ms)
#> ✔ Installed scales 1.4.0  (41ms)
#> ✔ Installed sourcetools 0.1.7-2  (23ms)
#> ✔ Installed shiny 1.14.0  (91ms)
#> ✔ Installed sys 3.4.3  (44ms)
#> ✔ Installed systemfonts 1.3.2  (73ms)
#> ✔ Installed tibble 3.3.1  (44ms)
#> ✔ Installed tidyselect 1.2.1  (41ms)
#> ✔ Installed tinytex 0.60  (39ms)
#> ✔ Installed utf8 1.2.6  (39ms)
#> ✔ Installed vctrs 0.7.3  (42ms)
#> ✔ Installed viridisLite 0.4.3  (41ms)
#> ✔ Installed withr 3.0.3  (67ms)
#> ✔ Installed xfun 0.60  (71ms)
#> ✔ Installed xtable 1.8-8  (41ms)
#> ✔ Installed yaml 2.3.12  (41ms)
#> ✔ Installed usfootballR 0.0.1 (github::sportsdataverse/usfootballR@1c596de) (41ms)
#> ✔ Installed clipr 0.8.1  (41ms)
#> ✔ Installed crayon 1.5.3  (40ms)
#> ✔ Installed credentials 2.0.3  (40ms)
#> ✔ Installed data.table 1.18.6.1  (84ms)
#> ✔ Installed furrr 0.4.0  (84ms)
#> ✔ Installed future 1.75.0  (43ms)
#> ✔ Installed gert 2.4.1  (44ms)
#> ✔ Installed gh 1.6.1  (41ms)
#> ✔ Installed gitcreds 0.1.2  (40ms)
#> ✔ Installed globals 0.19.1  (39ms)
#> ✔ Installed hms 1.1.4  (39ms)
#> ✔ Installed httr2 1.3.0  (75ms)
#> ✔ Installed ini 0.3.1  (48ms)
#> ✔ Installed janitor 2.2.1  (39ms)
#> ✔ Installed listenv 1.0.0  (40ms)
#> ✔ Installed lubridate 1.9.5  (42ms)
#> ✔ Installed parallelly 1.48.0  (43ms)
#> ✔ Installed progressr 1.0.0  (42ms)
#> ✔ Installed RcppParallel 6.2.1  (43ms)
#> ✔ Installed rstudioapi 0.19.0  (75ms)
#> ✔ Installed rvest 1.0.5  (44ms)
#> ✔ Installed selectr 0.6-0  (39ms)
#> ✔ Installed snakecase 0.11.1  (40ms)
#> ✔ Installed stringr 1.6.0  (22ms)
#> ✔ Installed stringi 1.8.9  (89ms)
#> ✔ Installed tidyr 1.3.2  (44ms)
#> ✔ Installed timechange 0.4.0  (41ms)
#> ✔ Installed usethis 3.2.1  (73ms)
#> ✔ Installed whisker 0.4.1  (41ms)
#> ✔ Installed xml2 1.6.0  (40ms)
#> ✔ Installed zip 3.0.2  (27ms)
#> ✔ 1 pkg + 118 deps: kept 1, upd 1, added 116, dld 111 (102.73 MB) [14.5s]
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
#> [1] "2026-08-29 17:04:26 EDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ── R CMD check results ─────────────────────── washington.spirit 0.0.0.9000 ────
#> Duration: 26.9s
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
