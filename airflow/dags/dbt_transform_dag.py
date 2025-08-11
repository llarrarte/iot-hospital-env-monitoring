from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(seconds=30),
}

dag = DAG(
    'dbt_transform_every_2min',
    default_args=default_args,
    description='Run dbt models every 2 minutes using BashOperator',
    schedule_interval='*/2 * * * *',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    max_active_runs=1
)

run_dbt = BashOperator(
    task_id='run_dbt_models',
    bash_command='/home/airflow/.local/bin/dbt run --project-dir /dbt --profiles-dir /dbt/profiles',
    dag=dag,
)
