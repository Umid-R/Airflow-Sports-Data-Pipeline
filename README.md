# ⚽ Football Data ELT Pipeline

![Python](https://img.shields.io/badge/Python-3.8%2B-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13%2B-blue)
![Airflow](https://img.shields.io/badge/Airflow-2.x-orange)

This project ingests and transforms historical football match data  for Europe’s **top five leagues**. It provides clean and aggregated statistics for teams, competitions, and matches. The pipeline is orchestrated using **Apache Airflow** and follows a modern **ELT architecture**.

---

## 🏗️ Project Overview

- **Source Data:** Football match data from [API-Football](https://www.api-football.com/)  
- **Architecture:** ELT (Extract → Load → Transform)  
- **Orchestration:** Apache Airflow (daily incremental updates)  
- **Database:** PostgreSQL (Bronze → Silver → Gold layers)  

**Layers explained:**
<img width="962" height="726" alt="image" src="https://github.com/user-attachments/assets/fec0e779-8a5f-47fa-98a3-b24ccc48155d" />


1. **Bronze Layer:** Raw API data for competitions, teams, and matches.  
2. **Silver Layer:** Cleaned and transformed data, combining match results and team information.  
3. **Gold Layer:** Aggregated analytics including team performance stats, league standings, and historical insights.

---

## ⚡ Key Features

- Incremental loading: Adds new matches daily without reprocessing all data.  
- Team performance analytics: Wins, draws, losses, goals scored/conceded, points, goal difference, win rate.  
- Multi-season support: Aggregates statistics for multiple seasons automatically.  
- ELT design: Separate raw ingestion, transformations, and analytical outputs.  
- Modular & reusable: SQL transformations are stored in separate files for easy updates.

---

## 🛠️ Technologies Used

- **Python 3** – main orchestration and ETL scripts  
- **Apache Airflow** – DAG scheduling and automation  
- **PostgreSQL** – data warehouse with Bronze, Silver, Gold layers  
- **Selenium & Pillow** – optional (used for automated Dino game demo if included)  
- **dotenv** – environment variable management  

---

## 🚀 Getting Started

1. Clone the repository:  
```bash
git clone <repo-url>
```


2. Install dependencies:
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

3.Configure .env file with your API credentials:
```bash
FOOTBALL_DATA_API_KEY=<your_api_key>
POSTGRES_HOST=localhost
POSTGRES_DB=football
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_PORT=5432
```

4.Start Docker for PostgreSQL and Airflow:
```bash
docker-compose up -d
```

5. Trigger the Airflow DAGs





