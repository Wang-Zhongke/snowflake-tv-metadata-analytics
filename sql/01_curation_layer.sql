-- 01_curation_layer.sql
-- Curation layer for Rich TV Metadata demo dataset

USE WAREHOUSE CHIPMUNK_wh;

CREATE OR REPLACE SCHEMA Wang_Proj_CUR;

-- Step 1: CUR_ALT_IDS - filter out null Asset Titles
CREATE OR REPLACE TABLE Wang_Proj_CUR.CUR_ALT_IDS AS
SELECT *
FROM RICH_TV_METADATA_TV_SERIES_MOVIES_ACTORS_AND_ID_MATCHING__DEMO.TV_METADATA.GET_ALT_IDS
WHERE "Asset Title" IS NOT NULL;

-- Step 2: Replace NULL alt IDs with 'Unknown'
UPDATE Wang_Proj_CUR.CUR_ALT_IDS SET 
"Opus ID"        = COALESCE("Opus ID", 'Unknown'),
"The Numbers"    = COALESCE("The Numbers", 'Unknown'),
"Justwatch ID"   = COALESCE("Justwatch ID", 'Unknown'),
"Rotten Tomatoes"= COALESCE("Rotten Tomatoes", 'Unknown'),
"Box Office Mojo"= COALESCE("Box Office Mojo", 'Unknown'),
"Red Bee"        = COALESCE("Red Bee", 'Unknown'),
"ISAN"           = COALESCE("ISAN", 'Unknown'),
"IVA"            = COALESCE("IVA", 'Unknown'),
"Baselihne"      = COALESCE("Baselihne", 'Unknown'),
"Variety"        = COALESCE("Variety", 'Unknown'),
"Amazon"         = COALESCE("Amazon", 'Unknown'),
"Comcast"        = COALESCE("Comcast", 'Unknown'),
"Sony"           = COALESCE("Sony", 'Unknown'),
"Warner Bros"    = COALESCE("Warner Bros", 'Unknown'),
"NBC"            = COALESCE("NBC", 'Unknown'),
"Facebook ID"    = COALESCE("Facebook ID", 'Unknown');

-- Step 3–10: CUR_MOVIES with derived fields
CREATE OR REPLACE TABLE Wang_Proj_CUR.CUR_MOVIES AS
SELECT DISTINCT
    *,
    CASE 
        WHEN "Start Year" >= 2015 THEN 'Yes'
        ELSE 'No'
    END AS IS_RECENT_RELEASE,
    CASE 
        WHEN "Start Year" IS NOT NULL THEN DATE_PART('year', CURRENT_DATE) - "Start Year"
        ELSE NULL
    END AS MOVIE_AGE,
    CASE 
        WHEN "Runtime" IS NULL THEN 'Unknown'
        WHEN "Runtime" < 90 THEN 'Short'
        WHEN "Runtime" BETWEEN 90 AND 120 THEN 'Standard'
        WHEN "Runtime" > 120 THEN 'Long'
    END AS MOVIE_LENGTH_CATEGORY,
    CASE 
        WHEN "Vote Count" >= 5000 THEN 'High'
        WHEN "Vote Count" >= 1000 THEN 'Medium'
        WHEN "Vote Count" IS NOT NULL THEN 'Low'
        ELSE 'Unknown'
    END AS POPULARITY_LEVEL,
    CASE 
        WHEN "Budget" IS NOT NULL AND "Revenue" IS NOT NULL AND "Budget" > 0 THEN 
            ROUND(("Revenue" * 0.5 - "Budget") / 1000000, 0)
        ELSE NULL
    END AS Total_Profit_in_millions,
    CASE 
        WHEN "Budget" IS NOT NULL AND "Revenue" IS NOT NULL AND "Budget" > 0 THEN 
            ROUND(("Revenue" * 0.5 - "Budget") / "Budget", 2)
        ELSE NULL
    END AS ROI,
    CASE 
        WHEN "Budget" IS NOT NULL AND "Revenue" IS NOT NULL AND "Budget" > 0 THEN
            CASE 
                WHEN ("Revenue" * 0.5 - "Budget") / "Budget" < 0 THEN 'Loss'
                WHEN ("Revenue" * 0.5 - "Budget") / "Budget" BETWEEN 0 AND 1 THEN 'Low Return'
                WHEN ("Revenue" * 0.5 - "Budget") / "Budget" >= 1 THEN 'Profitable'
            END
        ELSE 'Unknown'
    END AS ROI_CATEGORY
FROM RICH_TV_METADATA_TV_SERIES_MOVIES_ACTORS_AND_ID_MATCHING__DEMO.TV_METADATA.GET_MOVIES;

-- Step 11–13: CUR_PEOPLE with Is_Alive and Age
CREATE OR REPLACE TABLE Wang_Proj_CUR.CUR_PEOPLE AS
SELECT 
    *,
    CASE
        WHEN "Death Year" = '\\N' THEN 'Yes'
        ELSE 'No'
    END AS Is_Alive,
    CASE
        WHEN "Death Year" = '\\N' THEN CAST(ROUND(2025 - "Birth Year") AS STRING)
        ELSE 'DEAD'
    END AS Age
FROM RICH_TV_METADATA_TV_SERIES_MOVIES_ACTORS_AND_ID_MATCHING__DEMO.TV_METADATA.GET_PEOPLE;

-- Step 14–17: CUR_TV_SERIES with flags and popularity
CREATE OR REPLACE TABLE Wang_Proj_CUR.CUR_TV_SERIES AS
SELECT DISTINCT
    *,
    CASE 
        WHEN "Start Year" >= 2015 THEN 'Yes'
        ELSE 'No'
    END AS IS_RECENT_RELEASE,
    CASE 
        WHEN "Start Year" IS NOT NULL THEN DATE_PART('year', CURRENT_DATE) - "Start Year"
        ELSE NULL
    END AS TV_AGE,
    CASE 
        WHEN "Vote Count" >= 500 THEN 'High'
        WHEN "Vote Count" >= 50 THEN 'Medium'
        WHEN "Vote Count" IS NOT NULL THEN 'Low'
        ELSE 'Unknown'
    END AS POPULARITY_LEVEL
FROM RICH_TV_METADATA_TV_SERIES_MOVIES_ACTORS_AND_ID_MATCHING__DEMO.TV_METADATA.GET_TV_SERIES;
