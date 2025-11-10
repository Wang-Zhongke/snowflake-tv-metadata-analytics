# Snowflake TV & Movie Metadata Analytics

This repository contains the SQL scripts and documentation for a Snowflake-based
analytics project built on top of the **RSG Media – Rich TV Metadata: TV Series, Movies, Actors and ID Matching [Demo]** dataset.

> Note: The original course Snowflake account has expired.  
> All objects in this repo are provided as **re-runnable scripts** so that anyone
> can recreate the curated/aggregation layers in their own Snowflake environment.

## Goals

As a hypothetical content investor / producer, this project aims to answer:

- Which **genres** deliver the best Return on Investment (ROI)?
- Which **directors and actors** are consistently associated with successful titles?
- How do **runtime**, **popularity**, and **market trends by year** relate to profitability?

## Project Architecture

**Layers**

- `Wang_Proj_CUR` – Curation layer  
  - Cleans raw demo tables, removes invalid rows, standardizes IDs,
    and adds derived fields (ROI, ROI category, movie age, popularity, etc.).
- `Wang_Proj_AGG` – Aggregation layer  
  - Business-facing views for runtime performance, yearly trends,
    genre-level ROI, ranked directors and actors.
  - Re-usable table function and stored procedure for self-service analytics.

See `sql/01_curation_layer.sql` and `sql/02_aggregation_views.sql` for full DDL/DML.

## Key Objects

- Curated tables: `CUR_ALT_IDS`, `CUR_MOVIES`, `CUR_PEOPLE`, `CUR_TV_SERIES`
- Aggregation views:
  - `AGG_RUNTIME_CATEGORY_STATS`
  - `AGG_YEARLY_MOVIE_STATS`
  - `AGG_AVG_ROI_BY_GENRE`
  - `AGG_RANK_DIRECTORS`
  - `AGG_RANK_ACTORS`
- Table function:
  - `FUNC_RUNTIME_STATS_MIN_ROI(min_roi_threshold FLOAT)`
- Stored procedure:
  - `SPROC_TOP10_GENRE_BY_ROI()`

## How to Run

1. Create or log into a Snowflake account.
2. Run scripts in `sql/` in order:
   1. `01_curation_layer.sql`
   2. `02_aggregation_views.sql`
   3. `03_table_function_runtime_stats.sql`
   4. `04_stored_procedure_top_genres.sql`
3. Build dashboards (Snowflake worksheets or BI tools) on top of:
   - `AGG_YEARLY_MOVIE_STATS`
   - `AGG_AVG_ROI_BY_GENRE`
   - `AGG_RANK_DIRECTORS`
   - `AGG_RANK_ACTORS`
   - `FUNC_RUNTIME_STATS_MIN_ROI(...)`
   - `SPROC_TOP10_GENRE_BY_ROI()`

## Tech Stack

- Snowflake SQL
- Analytical data modeling (curated + aggregation layers)
- UDF-style table function & SQL stored procedure
- BI/dashboard concepts for content investment decisions

## About

This project was originally developed as part of my Data Science graduate coursework.
It is published here as a reproducible template to demonstrate:
practical Snowflake modeling, KPI design, and ROI-driven media analytics.
