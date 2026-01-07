



CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE silver.competitions;
    TRUNCATE TABLE silver.teams;
    TRUNCATE TABLE silver.matches;
    INSERT INTO silver.competitions (
        competition_id,
        competition_name,
        competition_code,
        competition_type,
        competition_emblem
    )
    SELECT DISTINCT
        c.cmt_id                             AS competition_id,
        TRIM(c.name)                     AS competition_name,
        c.code                           AS competition_code,
        c.type                           AS competition_type,
        c.emblem                         AS competition_emblem
    FROM bronze.competitions c
    WHERE c.cmt_id IS NOT NULL
    AND c.name IS NOT NULL;



    INSERT INTO silver.teams (
        team_id,
        name,
        short_name,
        team_abbr,
        team_logo,
        competition_id
    )
    SELECT DISTINCT
        t.team_id                       AS team_id,
        TRIM(t.name)               AS name,
        t.short_name,
        t.tla                      AS team_abbr,
        t.crest                    AS team_logo,
        t.competition_id
    FROM bronze.teams t
    WHERE t.team_id IS NOT NULL
    AND t.competition_id IS NOT NULL;



    INSERT INTO silver.matches (
        match_id,
        competition_id,
        season_id,
        matchday,
        stage,
        utc_date,
        status,
        home_team_id,
        away_team_id,
        winner,
        full_time_home,
        half_time_home,
        half_time_away
    )
    SELECT DISTINCT
        m.match_id                                AS match_id,
        m.competition_id,
        m.season_id,
        m.matchday,
        m.stage,
        m.utc_date::timestamp,
        m.status,
        m.home_team_id,
        m.away_team_id,
        m.winner,
        m.full_time_home,
        m.half_time_home,
        m.half_time_away
    FROM bronze.matches m
    WHERE m.match_id IS NOT NULL;


END;
$$;


CALL silver.load_silver();