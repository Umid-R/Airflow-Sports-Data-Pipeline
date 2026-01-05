from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta
from scripts.load_bronze import load_bronze


default_args = {
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="bronze_load_daily",
    start_date=datetime(2024, 1, 1),
    schedule_interval = "0 6 * * *",
    default_args=default_args,
    catchup=False,
    max_active_runs=1
) as dag:

    load_bronze_task = PythonOperator(
        task_id="load_bronze",
        python_callable=load_bronze
    )
    
   
