from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import sys
import os

# Make project root importable
PROJECT_ROOT = os.path.dirname(os.path.dirname(__file__))
sys.path.append(PROJECT_ROOT)

from scripts.load_bronze import load_bronze


with DAG(
    dag_id="bronze_load_daily",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=["bronze", "etl"],
) as dag:

    load_bronze_task = PythonOperator(
        task_id="load_bronze",
        python_callable=load_bronze,
    )
