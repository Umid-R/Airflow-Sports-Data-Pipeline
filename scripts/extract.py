import os
import requests
from dotenv import load_dotenv
import time 


load_dotenv()

API_KEY = os.getenv("FOOTBALL_DATA_API_KEY")


competitions=['PL','SA','FL1','BL1','PD']

DateFrom=None
DateTo=None
for com in competitions:
    
    url = f"https://api.football-data.org/v4/competitions/{com}/matches"
    params = {
    'season':'2023',
    "dateFrom": "2023-08-11",
    "dateTo": "2023-08-11",
    "status": "FINISHED",
    'limit':20
    
   
    }

    headers = {
        "X-Auth-Token": API_KEY
    }

    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status()

    data = response.json()
    print(data)
    time.sleep(1)



