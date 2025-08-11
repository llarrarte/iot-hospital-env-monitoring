from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'analytics',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'dbt_daily_analytics',
    default_args=default_args,
    description='Run dbt analytical models daily at midnight',
    schedule_interval='0 0 * * *',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    max_active_runs=1,
    tags=['dbt', 'analytics']
)

dbt_run = BashOperator(
    task_id='run_dbt_models',
    bash_command='/home/airflow/.local/bin/dbt run --select agg_avg_sensor_by_hour agg_daily_or_stats anomaly_flags agg_anomaly_summary --project-dir /dbt --profiles-dir /dbt/profiles',
    dag=dag,
)

dbt_test = BashOperator(
    task_id='run_dbt_tests',
    bash_command='/home/airflow/.local/bin/dbt test --project-dir /dbt --profiles-dir /dbt/profiles',
    dag=dag,
)

dbt_run >> dbt_test
