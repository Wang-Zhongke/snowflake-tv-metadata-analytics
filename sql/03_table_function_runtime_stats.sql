-- 03_table_function_runtime_stats.sql
-- Table function: filter runtime category stats by minimum ROI

CREATE OR REPLACE FUNCTION Wang_Proj_AGG.FUNC_RUNTIME_STATS_MIN_ROI(min_roi_threshold FLOAT)
RETURNS TABLE (
    MOVIE_LENGTH_CATEGORY STRING,
    MOVIE_COUNT INTEGER,
    AVG_BUDGET NUMBER(38,2),
    AVG_REVENUE NUMBER(38,2),
    AVG_ROI NUMBER(38,2)
)
AS
$$
    SELECT 
        MOVIE_LENGTH_CATEGORY,
        MOVIE_COUNT,
        AVG_BUDGET,
        AVG_REVENUE,
        AVG_ROI
    FROM Wang_Proj_AGG.AGG_RUNTIME_CATEGORY_STATS
    WHERE AVG_ROI >= min_roi_threshold
$$;

-- Example usage:
-- SELECT * FROM TABLE(Wang_Proj_AGG.FUNC_RUNTIME_STATS_MIN_ROI(1.6));
