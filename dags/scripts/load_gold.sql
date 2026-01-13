

DROP VIEW IF EXISTS gold.team_performance;

CREATE VIEW gold.team_performance AS

WITH team_match_flat AS (

    -- HOME TEAM perspective
    SELECT
        competition_id,
        home_team_id AS team_id,
        CASE WHEN winner = 'HOME' THEN 1 ELSE 0 END AS win,
        CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END AS draw,
        CASE WHEN winner = 'AWAY' THEN 1 ELSE 0 END AS loss,
        full_time_home AS goals_scored,
        full_time_away AS goals_conceded
    FROM silver.matches

    UNION ALL

    -- AWAY TEAM perspective
    SELECT
        competition_id,
        away_team_id AS team_id,
        CASE WHEN winner = 'AWAY' THEN 1 ELSE 0 END AS win,
        CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END AS draw,
        CASE WHEN winner = 'HOME' THEN 1 ELSE 0 END AS loss,
        full_time_away AS goals_scored,
        full_time_home AS goals_conceded
    FROM silver.matches
)

SELECT
    competition_id,
    team_id,
    COUNT(*) AS matches_played,
    SUM(win) AS wins,
    SUM(draw) AS draws,
    SUM(loss) AS losses,
    SUM(goals_scored) AS goals_scored,
    SUM(goals_conceded) AS goals_conceded,
    SUM(goals_scored)-SUM(goals_conceded) AS goal_difference,
    round((SUM(win)*3+SUM(draw)::DECIMAL)/COUNT(*),1) as points_per_match,
    round(SUM(win)::DECIMAL/COUNT(*),1)*100 || '%' AS win_rate,
    SUM(win)*3+SUM(draw)*1::DECIMAL AS points
FROM team_match_flat
GROUP BY competition_id, team_id
ORDER BY competition_id, points DESC;