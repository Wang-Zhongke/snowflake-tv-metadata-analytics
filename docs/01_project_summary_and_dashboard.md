# Project Summary & Dashboard Logic

## Dataset

**Name**: RSG Media – Rich TV Metadata: TV Series, Movies, Actors and ID Matching [Demo]  
**Content**:
- `GET_ALT_IDS`: Alternate platform IDs for titles
- `GET_MOVIES`: Movie metadata (titles, years, runtimes, budgets, revenues, votes, genres, descriptions)
- `GET_PEOPLE`: Actors/directors with birth/death years and awards
- `GET_TV_SERIES`: TV series metadata

## Schema & Naming

- `Wang_Proj_CUR`: Curation layer
  - `CUR_ALT_IDS`, `CUR_MOVIES`, `CUR_PEOPLE`, `CUR_TV_SERIES`
- `Wang_Proj_AGG`: Aggregation layer
  - `AGG_*` views
  - `FUNC_RUNTIME_STATS_MIN_ROI` table function
  - `SPROC_TOP10_GENRE_BY_ROI` stored procedure

## Key Transformations (Curation)

- Remove invalid/null records and standardize IDs to `'Unknown'`.
- Add derived business fields:
  - Recent release flags (`IS_RECENT_RELEASE`)
  - Age of movie/TV (`MOVIE_AGE`, `TV_AGE`)
  - Runtime categories (`Short`, `Standard`, `Long`)
  - Popularity tiers from vote counts
  - Profit (assuming producer receives 50% revenue)
  - ROI and `ROI_CATEGORY`
  - `Is_Alive` and `Age` for people

## Aggregation & Analytics

The aggregation views support:

- Performance by runtime category
- Yearly trends in budget, revenue, and ROI
- Genre-level ROI and awards
- Director and actor rankings (profitability, popularity, recognition)

## Dashboard Design Idea

Target user: **a movie producer / content investor**.

Suggested tiles / charts:

1. **Yearly Market Trend**
   - X: Year, Y: Avg ROI / Total Revenue
   - Insight: Is the market getting more profitable over time?

2. **Genres Profitability vs Popularity**
   - Bar or scatter: genres vs avg ROI / avg vote count
   - Highlight genres that are both popular and profitable
     (e.g. Animation, War, Adventure, Action, Romance, Drama).

3. **Top Directors & Actors**
   - Table or bar chart using `AGG_RANK_DIRECTORS` / `AGG_RANK_ACTORS`
   - Filters: profitable movies only, alive talent, awards count.

4. **Runtime Category Analysis**
   - Use `AGG_RUNTIME_CATEGORY_STATS` and `FUNC_RUNTIME_STATS_MIN_ROI`
   - Show which runtime buckets deliver acceptable ROI at different thresholds.

Business conclusion (example):

> Combining runtime, genre, and top-performing talent, this model guides producers
> toward movie profiles that balance manageable budgets with strong ROI potential.
