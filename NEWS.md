# washington.spirit 0.0.0.9000

* Player Explorer: pick a Washington Spirit player and season to see their
  Goals Added (g+) breakdown by action type, positional percentile ranks, and
  per-game form. Goalkeepers get the keeper-specific g+ actions.
* League Table: live NWSL standings from ESPN, with the Spirit highlighted and
  each club's crest shown between the rank and name.
* Data layer: `data-raw/refresh_data.R` pulls NWSL data (2016+) from American
  Soccer Analysis via `itscalledsoccer` into parquet snapshots under
  `inst/extdata/`, refreshed on a schedule by `.github/workflows/refresh-data.yaml`.
* CI: `R-CMD-check` and Codecov `test-coverage` GitHub Actions workflows run on
  every push and pull request to `main`.
* Branding: Washington Spirit palette (deep teal `#003A40` + yellow `#F3FB00`)
  applied via a `bslib` theme and `inst/app/www/custom.css`.
* Player headshots from ESPN's CDN, shown in the Player Explorer profile header;
  the roster crosswalk is built in `data-raw/refresh_data.R`.
* Every stat has a plain-English explanation: hover the info icons on the value
  boxes and card headers, or hover any chart bar (charts are now `ggiraph`).
  Definitions live in `R/fct_glossary.R`.
