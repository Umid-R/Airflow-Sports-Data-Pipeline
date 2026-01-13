DROP VIEW IF EXISTS gold.team_performance;

CREATE VIEW gold.team_performance AS

WITH team_match_flat AS (

    -- HOME TEAM perspective
    SELECT
        competition_id,
        season as season,
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
        season as season,
        away_team_id AS team_id,
        CASE WHEN winner = 'AWAY' THEN 1 ELSE 0 END AS win,
        CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END AS draw,
        CASE WHEN winner = 'HOME' THEN 1 ELSE 0 END AS loss,
        full_time_away AS goals_scored,
        full_time_home AS goals_conceded
    FROM silver.matches
),

team_stats AS (
    SELECT
        competition_id,
        season,
        team_id,
        COUNT(*) AS matches_played,
        SUM(win) AS wins,
        SUM(draw) AS draws,
        SUM(loss) AS losses,
        SUM(goals_scored) AS goals_scored,
        SUM(goals_conceded) AS goals_conceded,
        SUM(goals_scored) - SUM(goals_conceded) AS goal_difference,
        SUM(win)*3 + SUM(draw) AS points,
        ROUND((SUM(win)*3 + SUM(draw))::DECIMAL / COUNT(*), 1) AS points_per_match,
        ROUND(SUM(win)::DECIMAL / COUNT(*) * 100, 1) || '%' AS win_rate
    FROM team_match_flat
    GROUP BY competition_id,season, team_id
)



SELECT
    s.competition_id,
    c.league_name,
    t.country,
    s.season,
    s.team_id,
    t.name,
    ROW_NUMBER() OVER (
        PARTITION BY competition_id, season
        ORDER BY points DESC, goal_difference DESC
    ) AS rank,
    s.matches_played,
    s.wins,
    s.draws,
    s.losses,
    s.goals_scored,
    s.goals_conceded,
    s.goal_difference,
    s.points_per_match,
    s.win_rate,
    s.points
    
FROM team_stats s
LEFT JOIN silver.teams t
ON s.team_id=t.team_id
LEFT JOIN silver.competitions c
ON c.league_id=s.competition_id
ORDER BY season DESC; 
