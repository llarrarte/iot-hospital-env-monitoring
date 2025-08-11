FROM apache/airflow:2.9.1-python3.10

USER airflow
RUN pip install --no-cache-dir dbt-core dbt-postgres

ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
