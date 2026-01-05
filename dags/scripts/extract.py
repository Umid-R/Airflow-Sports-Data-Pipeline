import os
import requests
from dotenv import load_dotenv
from datetime import datetime
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

load_dotenv()

API_KEY = os.getenv("FOOTBALL_DATA_API_KEY")

headers = {
    "X-Auth-Token": API_KEY
}

competitions = ['PL', 'SA', 'FL1', 'BL1', 'PD']

# 🔁 Create session with retries
session = requests.Session()
retries = Retry(
    total=5,
    backoff_factor=2,
    status_forcelist=[429, 500, 502, 503, 504],
    allowed_methods=["GET"]
)
session.mount("https://", HTTPAdapter(max_retries=retries))


def extract_matches(dateFrom: datetime, dateTo: datetime):
    year = dateFrom.year if dateFrom.month >= 8 else dateFrom.year - 1

    data = []
    for com in competitions:
        url = f"https://api.football-data.org/v4/competitions/{com}/matches"
        params = {
            "season": year,
            "dateFrom": dateFrom.strftime("%Y-%m-%d"),
            "dateTo": dateTo.strftime("%Y-%m-%d"),
            "status": "FINISHED"
        }

        response = session.get(
            url,
            headers=headers,
            params=params,
            timeout=30   # ⏱️ VERY IMPORTANT
        )
        response.raise_for_status()
        data.append(response.json())

    return data


def extract_teams(date: datetime):
    year = date.year if date.month >= 8 else date.year - 1

    teams = []
    for com in competitions:
        url = f"https://api.football-data.org/v4/competitions/{com}/teams"
        params = {"season": year}

        response = session.get(
            url,
            headers=headers,
            params=params,
            timeout=30
        )
        response.raise_for_status()
        teams.append(response.json())

    return teams
