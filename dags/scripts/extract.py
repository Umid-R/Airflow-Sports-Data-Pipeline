import os
import requests
from dotenv import load_dotenv
from datetime import datetime


load_dotenv()

API_KEY = os.getenv("FOOTBALL_DATA_API_KEY")

headers = {
            "X-Auth-Token": API_KEY
        }


competitions=['PL','SA','FL1','BL1','PD']



def  extract_matches(dateFrom:datetime, dateTo:datetime):
    year = dateFrom.year if dateFrom.month >= 8 else dateFrom.year - 1

    data=[]
    for com in competitions:
        
        url = f"https://api.football-data.org/v4/competitions/{com}/matches"
        params = {
        'season':year,
        "dateFrom": dateFrom.strftime("%Y-%m-%d"),
        "dateTo": dateTo.strftime("%Y-%m-%d"),
        "status": "FINISHED"
        
        
    
        }

        

        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()

        data.append(response.json())
        
    return data

def extract_teams(date:datetime):
    year = date.year if date.month >= 8 else date.year - 1

    teams=[]
    for com in competitions:
        url=f'https://api.football-data.org/v4/competitions/{com}/teams'
        params = {
        'season':year
        }
        response = requests.get(url, headers=headers,params=params)
        response.raise_for_status()
        
        teams.append(response.json())
        
    return teams


        



  



