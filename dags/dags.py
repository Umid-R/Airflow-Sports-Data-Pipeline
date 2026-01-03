from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from scripts.load_bronze import load_bronze


with DAG(
    dag_id="bronze_load_daily",
    start_date=datetime(2024, 1, 1),
    schedule_interval="5 0 * * *",
    catchup=False
) as dag:

    load_bronze_task = PythonOperator(
        task_id="load_bronze",
        python_callable=load_bronze
    )
    
   
