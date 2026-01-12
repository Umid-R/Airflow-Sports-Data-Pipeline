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






    # Load competitions into bronze.competitions
    # Competitions change rarely, so this block is typically run once.
    # It is idempotent and safe to re-run (existing records are skipped).


    if data:
        for league in data:
            for competition  in league['response'] :
        
                sql = """
                    INSERT INTO bronze.competitions (
                        id, name, country, logo, flag
                    )
                    VALUES (%s, %s, %s, %s, %s)
                    ON CONFLICT (id) DO NOTHING;
                    """    
                
                row = (
                    competition['league']['id'],
                    competition['league']['name'],
                    competition['league']['country'],
                    competition['league']['logo'],
                    competition['league']['flag']
                
                )
                cur.execute(sql, row)
                
    


    # Load daily match data into bronze.matches
    # This block is designed to run daily.
    # New matches are inserted; existing matches are skipped using the primary key.

    if data:
        for league in data:
            for match in league['response']:
            
                
                    sql = """
                        INSERT INTO bronze.matches (
                            match_id,
                            competition_id,
                            season,
                            round,
                            date,
                            status,
                            home_team_id,
                            away_team_id,
                            winner_home,
                            winner_away,
                            full_time_home,
                            full_time_away,
                            half_time_home,
                            half_time_away
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (match_id) DO NOTHING;
                        """
                    row=(
                        match['fixture']['id'],
                        match['league']['id'],
                        match['league']['season'],
                        match['league']['round'],
                        match['fixture']['date'],
                        match['fixture']['status']['long'],
                        match['teams']['home']['id'],
                        match['teams']['away']['id'],
                        match['teams']['home']['winner'],
                        match['teams']['away']['winner'],
                        match['score']['fulltime']['home'],
                        match['score']['fulltime']['away'],
                        match['score']['halftime']['home'],
                        match['score']['halftime']['away']
                    )
                    cur.execute(sql, row)
              

                    
                    
    # Load teams into bronze.teams
    # Team data is sourced from a separate API endpoint.
    # This block is safe to run multiple times; duplicates are avoided via primary key.

    for league in teams:
        for team in league['response']:
            sql = """
                INSERT INTO bronze.teams (
                    team_id,
                    name,
                    short_name,
                    country,
                    logo
                    
                )
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (team_id) DO NOTHING;
            """
            
            row = (
                team['team']['id'],
                team['team']['name'],
                team['team']['code'],
                team['team']['country'],
                team['team']['logo'],
                
            )

            cur.execute(sql, row)
           
            
            

                    
    conn.commit()
    cur.close()
    conn.close()
    

if __name__ == "__main__":
    load_bronze()