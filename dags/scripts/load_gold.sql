-- ============================================================
-- Team performance analysis by league
--
-- Output columns:
--   team_id
--   competition_id
--   matches_played
--   wins
--   draws
--   losses
--   goals_scored
--   goals_conceded
-- ============================================================
CREATE OR REPLACE VIEW gold.team_performance AS

WITH win_events AS (
    SELECT
        home_team_id AS team_id,
        COUNT(*) AS wins,
        SUM(full_time_home) AS goals_scored,
        SUM(full_time_away) AS goals_conceded
    FROM silver.matches
    WHERE winner = 'HOME_TEAM'
    GROUP BY home_team_id

    UNION ALL

    SELECT
        away_team_id AS team_id,
        COUNT(*) AS wins,
        SUM(full_time_away) AS goals_scored,
        SUM(full_time_home) AS goals_conceded
    FROM silver.matches
    WHERE winner = 'AWAY_TEAM'
    GROUP BY away_team_id
),

team_matches AS (
    SELECT
        t.competition_id,
        t.team_id,
        COUNT(*) AS matches_played
    FROM (
        SELECT
            competition_id,
            home_team_id AS team_id
        FROM silver.matches

        UNION ALL

        SELECT
            competition_id,
            away_team_id AS team_id
        FROM silver.matches
    ) t
    GROUP BY
        t.competition_id,
        t.team_id
),

draw_events AS (
    SELECT
        home_team_id AS team_id,
        COUNT(*) AS draws,
        SUM(full_time_home) AS goals_scored,
        SUM(full_time_away) AS goals_conceded
    FROM silver.matches
    WHERE winner = 'DRAW'
    GROUP BY home_team_id

    UNION ALL

    SELECT
        away_team_id AS team_id,
        COUNT(*) AS draws,
        SUM(full_time_away) AS goals_scored,
        SUM(full_time_home) AS goals_conceded
    FROM silver.matches
    WHERE winner = 'DRAW'
    GROUP BY away_team_id
),

loss_events AS (
    SELECT
        home_team_id AS team_id,
        COUNT(*) AS losses,
        SUM(full_time_home) AS goals_scored,
        SUM(full_time_away) AS goals_conceded
    FROM silver.matches
    WHERE winner = 'AWAY_TEAM'
    GROUP BY home_team_id

    UNION ALL

    SELECT
        away_team_id AS team_id,
        COUNT(*) AS losses,
        SUM(full_time_away) AS goals_scored,
        SUM(full_time_home) AS goals_conceded
    FROM silver.matches
    WHERE winner = 'HOME_TEAM'
    GROUP BY away_team_id
),

aggregated_events AS (
    SELECT
        team_id,
        0 AS wins,
        SUM(draws) AS draws,
        0 AS losses,
        SUM(goals_scored) AS goals_scored,
        SUM(goals_conceded) AS goals_conceded
    FROM draw_events
    GROUP BY team_id

    UNION ALL

    SELECT
        team_id,
        SUM(wins) AS wins,
        0 AS draws,
        0 AS losses,
        SUM(goals_scored) AS goals_scored,
        SUM(goals_conceded) AS goals_conceded
    FROM win_events
    GROUP BY team_id

    UNION ALL

    SELECT
        team_id,
        0 AS wins,
        0 AS draws,
        SUM(losses) AS losses,
        SUM(goals_scored) AS goals_scored,
        SUM(goals_conceded) AS goals_conceded
    FROM loss_events
    GROUP BY team_id
),

team_stats AS (
    SELECT
        team_id,
        SUM(wins) AS wins,
        SUM(draws) AS draws,
        SUM(losses) AS losses,
        SUM(goals_scored) AS goals_scored,
        SUM(goals_conceded) AS goals_conceded
    FROM aggregated_events
    GROUP BY team_id
),

final_team_performance AS (
    SELECT
        tm.*,
        ts.wins,
        ts.draws,
        ts.losses,
        ts.goals_scored,
        ts.goals_conceded
    FROM team_matches tm
    LEFT JOIN team_stats ts
        ON tm.team_id = ts.team_id
)

SELECT *
FROM final_team_performance;





