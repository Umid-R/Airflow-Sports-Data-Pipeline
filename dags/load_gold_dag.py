from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta


default_args = {
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="load_gold",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    default_args=default_args,
    catchup=False,
) as dag:

    load_silver = PostgresOperator(
        task_id="load_gold",
        postgres_conn_id="postgres_localhost",
        sql="scripts/load_gold.sql",
    )
