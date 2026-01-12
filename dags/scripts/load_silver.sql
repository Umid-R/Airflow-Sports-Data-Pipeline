



CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE silver.competitions;
    TRUNCATE TABLE silver.teams;
    TRUNCATE TABLE silver.matches;
    INSERT INTO silver.competitions (
        league_id ,           
        league_name ,      
        league_country,               
        league_logo,                
        league_flag
    )
    SELECT DISTINCT
        c.id                             AS league_id,
        TRIM(c.name)                     AS league_name ,
        c.country                        AS league_country ,
        c.logo                           AS league_logo,
        c.flag                         AS league_flag
    FROM bronze.competitions c
    WHERE c.id IS NOT NULL
    AND c.name IS NOT NULL;



    INSERT INTO silver.teams (
        team_id,
        name,
        short_name,
        country,
        team_logo
     
    )
    SELECT DISTINCT
        t.team_id                       AS team_id,
        TRIM(t.name)               AS name,
        t.short_name,
        t.country                  AS country,
        t.logo                    AS team_logo
        
    FROM bronze.teams t
    WHERE t.team_id IS NOT NULL;



    INSERT INTO silver.matches (
        match_id,         
        competition_id,               
        season,               
        round,     
        date,             
        status,               
        home_team_id,      
        away_team_id,     
        winner,
        full_time_home,
        full_time_away,              
        half_time_home,              
        half_time_away 
    )
    SELECT DISTINCT
        m.match_id,         
        m.competition_id,               
        m.season,               
        m.round,     
        m.date,             
        m.status,               
        m.home_team_id,      
        m.away_team_id,

        CASE
            WHEN m.winner_home='true' THEN 'HOME'
            WHEN m.winner_away='true' THEN 'AWAY'
            ELSE 'DRAW'
        END AS winner,

        m.full_time_home,
        m.full_time_away,              
        m.half_time_home,              
        m.half_time_away
    FROM bronze.matches m
    WHERE m.match_id IS NOT NULL;


END;
$$;


CALL silver.load_silver();