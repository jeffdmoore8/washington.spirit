# data-raw

## `refresh_data.R`

Rebuilds every data snapshot the app reads. Pulls NWSL data from
[American Soccer Analysis](https://app.americansocceranalysis.com/) via the
`itscalledsoccer` package and writes tidy parquet files to `inst/extdata/`,
where `load_app_data()` (see [`R/fct_data.R`](../R/fct_data.R)) reads them.

```sh
Rscript data-raw/refresh_data.R
```

- League-wide player season tables (`player_*_by_season.parquet`) are kept whole
  - they are the population for positional percentile ranks.
- Per-game tables (`player_*_by_game.parquet`) are filtered to the Spirit via
  `team_ids` and tagged with season/kickoff from the `games` snapshot.
- Goals-added tables are unnested to long form (`action_type`, `goals_added_raw`,
  `goals_added_above_avg`, `count_actions`).
- `season` is coerced to integer in every snapshot.

Coverage note: ASA NWSL data begins in **2016** (`ASA_FIRST_SEASON`). ESPN /
`usfootballR` is **not** used for snapshots - its NWSL loaders are broken; only
the live `espn_nwsl_standings()` call in `mod_league_table` touches ESPN.

## Scheduled refresh

[`.github/workflows/refresh-data.yaml`](../.github/workflows/refresh-data.yaml)
runs this script daily and commits any changed snapshots.
