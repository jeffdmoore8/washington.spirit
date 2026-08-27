# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A [golem](https://thinkr-open.github.io/golem/) Shiny application packaged as the R package `washington.spirit` — fan-facing NWSL analytics centered on the Washington Spirit. Two tabs: **Player explorer** (goals-added profile, positional percentiles, per-game form) and **League table** (live NWSL standings).

The app is **offline-first**: at runtime it reads pre-built parquet snapshots from `inst/extdata/`. The only runtime network call is the live ESPN standings fetch in `mod_league_table`. All other data is baked in ahead of time by `data-raw/refresh_data.R`.

## Commands

R is at `/usr/local/bin/R`. Run these from the repo root.

```bash
# Run the app (dev mode: documents + reloads first)
Rscript -e 'source("dev/run_dev.R")'
# or, if the package is installed: Rscript -e 'washington.spirit::run_app()'

# All tests
Rscript -e 'devtools::test()'

# A single test file
Rscript -e 'testthat::test_file("tests/testthat/test-fct_player.R")'

# Regenerate NAMESPACE + man/ after changing roxygen or adding exports
Rscript -e 'devtools::document()'

# Full R CMD check
Rscript -e 'devtools::check()'

# Rebuild every data snapshot from American Soccer Analysis (slow; hits the ASA API)
Rscript data-raw/refresh_data.R
```

Installing R packages on this machine: use `pak::pkg_install()` one or a few at a time. `install.packages()` is not the house tool, and **any pak GitHub install fails** here (stale PAT in the credential store → HTTP 401). `usfootballR` sits in `DESCRIPTION` `Remotes:` for this reason — if it needs reinstalling, fetch the tarball anonymously and `R CMD INSTALL` it.

## Architecture

### Data pipeline (`data-raw/refresh_data.R` → `inst/extdata/*.parquet` → `R/fct_data.R`)

- `refresh_data.R` pulls NWSL data (2016+; earlier seasons return nothing) from **American Soccer Analysis** via `itscalledsoccer`, and writes ~13 tidy parquet files. It is run on a schedule by `.github/workflows/refresh-data.yaml`, which commits any changed snapshots.
- `APP_DATA_FILES` in `R/fct_data.R` is the manifest: `<list slot> = <filename>`. `load_app_data()` reads every file that exists into a named list (missing files → `NULL` slot + a warning, so the UI degrades instead of crashing). It is **memoised for the life of the process** — cheap to call from every module server; `app_server` calls it once and passes the plain list (not a reactive) into modules.
- To add a dataset: add a slot to `APP_DATA_FILES`, write it in `refresh_data.R` via `write_snapshot()`, consume it through `app_data$<slot>` in a `fct_*` helper.

### Data-source rules (do not relitigate)

- **ASA only** for snapshots. `usfootballR`'s NWSL loaders are broken (every `load_nwsl_*` 404s, `espn_nwsl_scoreboard()` returns nothing). The one sanctioned ESPN touch is `usfootballR::espn_nwsl_standings(year=)` in `mod_league_table`. No shot maps / box scores / events — ASA publishes no per-shot events.
- Team ids: Spirit = `aDQ0lzvQEv` (ASA), `15365` (ESPN). Constants live in `R/fct_data.R` (`SPIRIT_ASA_TEAM_ID`, `SPIRIT_ESPN_TEAM_ID`, `ASA_FIRST_SEASON`).

### ASA API quirks (encoded in `R/fct_asa.R`)

- Per-game pulls **must** pass `team_ids = SPIRIT_ASA_TEAM_ID` — a league-wide per-game pull across all seasons times out.
- `get_player_*` return `team_id` as a **list-column** unless `split_by_teams = TRUE`; `flatten_team_id()` is the fallback.
- Goals-added endpoints return a nested `data` list-column (`action_type`, `goals_added_raw`, `goals_added_above_avg`, `count_actions`); `unnest_goals_added()` expands it to long form.
- `season` is coerced to **integer** in every snapshot (the API sends it as a string on `*_by_season` endpoints). Keep it that way.
- Minutes column is `minutes_played`. Position is `general_position` and lives only on the stats endpoints, not `get_players()`.

### App code layout

- `R/app_ui.R` — `bslib::page_navbar` shell + theme; `golem_add_external_resources()` auto-bundles `inst/app/www/` (`custom.css` is picked up automatically — no manual `tags$link`).
- `R/app_server.R` — loads data once, wires the two modules.
- `R/mod_player_explorer.R`, `R/mod_league_table.R` — the two `moduleServer` modules.
- `R/fct_player.R` — pure transforms from snapshots → the exact frame each panel plots. Kept out of the module so they are unit-tested (`test-fct_player.R` with in-memory `fake_data()`).
- `R/fct_metrics.R` — `pct_rank`, `per90`, `add_positional_percentiles` (ranks within `general_position` above a minutes floor), `spirit_roster`, `spirit_seasons`.
- `R/fct_plots.R` — `ggiraph` interactive chart builders. `spirit_girafe()` wraps every chart: `opts_sizing(rescale = FALSE)` keeps an intrinsic SVG height, and `custom.css` scales `.girafe_container_std svg` to `width:100%; height:auto; max-width:1050px`. Smaller `width_svg` ⇒ larger on-screen text.
- `R/fct_glossary.R` — `stat_glossary` maps the **exact user-visible label** → plain-English text; `stat_label()` / `info_icon()` render the hover icons; `stat_tooltip()` builds per-bar chart tooltips. When you add or rename a stat/action label anywhere, add the matching glossary key.
- `R/fct_roster.R` — ESPN roster + headshots (built in `refresh_data.R`, not at runtime). Headshots come from ESPN's CDN. ESPN's WAF 403s browser-like and libcurl UAs; use `httr::user_agent("curl/8")`. Athletes match ASA `player_id` by `normalize_name()`.

### Branding

Deep teal `#003A40` + high-voltage yellow `#F3FB00`. Single source of truth: `spirit_palette` in `R/fct_plots.R`; applied via `bslib::bs_theme()` in `app_ui.R` and `inst/app/www/custom.css`. Yellow has near-zero contrast on white — on light surfaces teal does the work; yellow is for dark chrome and small highlights only. Fonts: Barlow / Barlow Condensed via `font_google(local = FALSE)` so an offline start still works.

## Conventions

- **Indentation is tabs**, matching the existing source.
- Internal functions use `#' @noRd` roxygen (not exported); only `run_app()` is exported. Run `devtools::document()` after touching roxygen tags or `@importFrom`.
- Expensive/repeated work is `memoise`d (`asa_client`, `load_app_data`, `fetch_nwsl_standings` with a 30-min `cachem` TTL).
- New dependencies: add to `DESCRIPTION` (`attachment::att_amend_desc()` is the intended tool) and record user-facing changes in `NEWS.md`.
- `README.md` is generated from `README.Rmd` — edit the `.Rmd`.
