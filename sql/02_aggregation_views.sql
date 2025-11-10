-- 02_aggregation_views.sql
-- Aggregation views on top of curated layer

CREATE OR REPLACE SCHEMA Wang_Proj_AGG;

-- View 1: Runtime category stats
CREATE OR REPLACE VIEW Wang_Proj_AGG.AGG_RUNTIME_CATEGORY_STATS AS
SELECT 
    MOVIE_LENGTH_CATEGORY,
    COUNT(*) AS MOVIE_COUNT,
    ROUND(AVG("Budget"), 2) AS AVG_BUDGET,
    ROUND(AVG("Revenue"), 2) AS AVG_REVENUE,
    ROUND(AVG(ROI), 2) AS AVG_ROI
FROM Wang_Proj_CUR.CUR_MOVIES
GROUP BY MOVIE_LENGTH_CATEGORY
ORDER BY AVG_REVENUE DESC;

-- View 2: Yearly movie stats (post-2000)
CREATE OR REPLACE VIEW Wang_Proj_AGG.AGG_YEARLY_MOVIE_STATS AS
SELECT 
    "Start Year" AS START_YEAR,
    COUNT(*) AS MOVIE_COUNT,
    ROUND(AVG(ROI), 2) AS AVG_ROI,
    ROUND(AVG("Revenue") / 1000000) AS AVG_REVENUE_MILLIONS,
    ROUND(SUM("Revenue") / 1000000) AS SUM_REVENUE_MILLIONS,
    ROUND(AVG("Budget") / 1000000) AS AVG_BUDGET_MILLIONS,
    ROUND(SUM("Budget") / 1000000) AS SUM_BUDGET_MILLIONS
FROM Wang_Proj_CUR.CUR_MOVIES
WHERE "Start Year" IS NOT NULL
  AND "Start Year" > 2000
GROUP BY "Start Year"
ORDER BY START_YEAR;

-- View 3: Average ROI by genre
CREATE OR REPLACE VIEW Wang_Proj_AGG.AGG_AVG_ROI_BY_GENRE AS
SELECT
  f.value:"name"::STRING AS genre,
  COUNT(*) AS genre_count,
  ROUND(AVG(ARRAY_SIZE("Awards"))) AS awards_number,
  ROUND(AVG(ROI), 2) AS AVG_ROI,
  ROUND(MAX(ROI), 2) AS MAX_ROI,
  ROUND(MIN(ROI), 2) AS MIN_ROI,
  ROUND(AVG("Vote Count")) AS avg_Vote_Count,
  ROUND(AVG(Total_Profit_in_millions)) AS AVG_Profit_in_millions
FROM Wang_Proj_CUR.CUR_MOVIES,
     LATERAL FLATTEN(input => "Genres") AS f
GROUP BY genre
ORDER BY AVG_ROI DESC;

-- View 4: Rank directors (profitable, alive)
CREATE OR REPLACE VIEW Wang_Proj_AGG.AGG_RANK_DIRECTORS AS
SELECT 
  TRIM(f.value::STRING) AS director,
  COUNT(*) AS movie_count,
  ARRAY_SIZE(p."Awards") AS awards_number,
  ROUND(AVG(m.ROI), 2) AS ROI,
  ROUND(AVG(m."Vote Count")) AS avg_Vote_Count,
  ROUND(AVG(m.Total_Profit_in_millions)) AS "Total Profit(millions)",
  p.Is_Alive,
  p.AGE
FROM Wang_Proj_CUR.CUR_MOVIES m,
     LATERAL FLATTEN(input => m."Directors") f
INNER JOIN Wang_Proj_CUR.CUR_PEOPLE p
  ON TRIM(f.value::STRING) = p."Name"
WHERE m.ROI_CATEGORY = 'Profitable'
  AND p.Is_Alive = 'Yes'
GROUP BY director, p.Is_Alive, p.AGE, awards_number
ORDER BY movie_count DESC, awards_number DESC;

-- View 5: Rank actors/actresses (popular, >1 film)
CREATE OR REPLACE VIEW Wang_Proj_AGG.AGG_RANK_ACTORS AS
SELECT 
  TRIM(f.value::STRING) AS actor,
  ARRAY_SIZE(p."Awards") AS awards_number,
  ROUND(AVG(m."Vote Count")) AS avg_Vote_Count,
  COUNT(*) AS movie_count,
  p.AGE,
  p."Gender"
FROM Wang_Proj_CUR.CUR_MOVIES m,
     LATERAL FLATTEN(input => m."Actors") f
INNER JOIN Wang_Proj_CUR.CUR_PEOPLE p
  ON TRIM(f.value::STRING) = p."Name"
WHERE m.POPULARITY_LEVEL != 'Low'
  AND p.Is_Alive = 'Yes'
GROUP BY actor, p.Is_Alive, p.AGE, awards_number, p."Gender"
HAVING COUNT(*) > 1
ORDER BY awards_number DESC, avg_Vote_Count DESC;
