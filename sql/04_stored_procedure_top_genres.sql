-- 04_stored_procedure_top_genres.sql
-- Stored procedure: return top 10 genres by average ROI

CREATE OR REPLACE PROCEDURE Wang_Proj_AGG.SPROC_TOP10_GENRE_BY_ROI()
RETURNS TABLE (
    genre STRING,
    genre_count INTEGER,
    avg_roi NUMBER(38,2),
    max_roi NUMBER(38,2),
    min_roi NUMBER(38,2),
    awards_number NUMBER(38,2),
    avg_vote_count NUMBER(38,2),
    avg_profit_in_millions NUMBER(38,2)
)
LANGUAGE SQL
AS
$$
DECLARE
  res RESULTSET;
BEGIN
  res := (
    SELECT
      genre,
      genre_count,
      avg_roi,
      max_roi,
      min_roi,
      awards_number,
      avg_vote_count,
      avg_profit_in_millions
    FROM Wang_Proj_AGG.AGG_AVG_ROI_BY_GENRE
    ORDER BY avg_roi DESC
    LIMIT 10
  );
  RETURN TABLE(res);
END;
$$;

-- Example:
-- CALL Wang_Proj_AGG.SPROC_TOP10_GENRE_BY_ROI();
