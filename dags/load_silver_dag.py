from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

with DAG(
    dag_id="load_silver",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    load_silver = PostgresOperator(
        task_id="load_silver",
        postgres_conn_id="postgres_localhost",
        sql="scripts/load_silver.sql",
    )
