import psycopg2
from .extract_data import extract_matches, extract_teams
import os 
from dotenv import load_dotenv
from datetime import timedelta

def load_bronze():
    load_dotenv()

    conn = psycopg2.connect(
        host=os.getenv('host'),
        database=os.getenv('database'),
        user=os.getenv('user'),
        password=os.getenv("password"),
        port=os.getenv('port')
    )

    cur = conn.cursor()

    # Get the latest date to get new data 
    cur.execute("""
        SELECT MAX(date)
        FROM bronze.dates;
    """)
    latest_date = (cur.fetchone()[0])
    print(latest_date)
    new_date = latest_date + timedelta(days=1)
    
    
    # Add new date for tomorrow
    cur.execute(f"""
    INSERT INTO bronze.dates(date)
    VALUES
    (CAST('{new_date}' AS DATE));
    """)


    data=extract_matches(new_date, new_date)
    teams=extract_teams(new_date)

    competition_count = 0
    match_count = 0
    team_count = 0




    # Load competitions into bronze.competitions
    # Competitions change rarely, so this block is typically run once.
    # It is idempotent and safe to re-run (existing records are skipped).



    for competition  in data :
        
        sql = """
            INSERT INTO bronze.competitions (
                cmt_id, name,code, type, emblem
            )
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (cmt_id) DO NOTHING;
            """    
        
        row = (
            competition['competition']['id'],
            competition['competition']['name'],
            competition['competition']['code'],
            competition['competition']['type'],
            competition['competition']['emblem'],
        
        )
        cur.execute(sql, row)
        competition_count+=1
    print(f"Inserted competitions: {competition_count}")


    # Load daily match data into bronze.matches
    # This block is designed to run daily.
    # New matches are inserted; existing matches are skipped using the primary key.


    for competition in data:
        if competition['matches']:
            for match in competition['matches']: 
                sql = """
                    INSERT INTO bronze.matches (
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
                        full_time_away,
                        half_time_home,
                        half_time_away
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (match_id) DO NOTHING;
                    """
                row=(
                    match['id'],
                    match['competition']['id'],
                    match['season']['id'],
                    match['matchday'],
                    match['stage'],
                    match['utcDate'],
                    match['status'],
                    match['homeTeam']['id'],
                    match['awayTeam']['id'],
                    match['score']['winner'],
                    match['score']['fullTime']['home'],
                    match['score']['fullTime']['away'],
                    match['score']['halfTime']['home'],
                    match['score']['halfTime']['away']
                )
                cur.execute(sql, row)
                match_count+=1
    print(f"Inserted matches: {match_count}")          

                    
                    
    # Load teams into bronze.teams
    # Team data is sourced from a separate API endpoint.
    # This block is safe to run multiple times; duplicates are avoided via primary key.

    for competition in teams:
        for team in competition['teams']:
            sql = """
                INSERT INTO bronze.teams (
                    team_id,
                    name,
                    short_name,
                    tla,
                    crest,
                    competition_id
                )
                VALUES (%s, %s, %s, %s, %s, %s)
                ON CONFLICT (team_id) DO NOTHING;
            """
            
            row = (
                team['id'],
                team['name'],
                team['shortName'],
                team['tla'],
                team['crest'],
                team['runningCompetitions'][0]['id']
            )

            cur.execute(sql, row)
            team_count+=1

    print(f"Inserted teams: {team_count}")
            
            

                    
    conn.commit()
    cur.close()
    conn.close()
    

if __name__ == "__main__":
    load_bronze()