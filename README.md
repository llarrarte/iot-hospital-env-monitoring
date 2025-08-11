# Hospital IoT Analytics Platform

## Overview

This project is a fully containerized **IoT data pipeline and analytics platform** designed to simulate and process environmental sensor data (CO₂, CO, and temperature) from **Operating Rooms (ORs)** across multiple hospitals. The system includes real-time data ingestion, a dimensional star schema, transformation using dbt, orchestration with Airflow, and dashboards using Superset and/or Metabase.

The stack is ideal for learning and demonstrating **data engineering, analytics, and monitoring** workflows, especially in healthcare or industrial IoT contexts.

---

## What the Platform Does

- ⌚ **Simulates high-frequency IoT sensor data** for hospital ORs using MQTT
- 🧑‍💻 **Ingests data into PostgreSQL** via a real-time Python MQTT consumer
- 📊 **Transforms data with DBT** into a star schema with fact/dimension tables
- ⏳ **Schedules incremental transformations** with Airflow
- ⚠️ **Detects anomalies** (e.g. high CO₂, extreme temperatures)
- 📉 **Aggregates hourly/daily stats** for analysis
- 🔍 **Explores data via Superset and Metabase dashboards**

---

## Architecture Diagram

```text
                        +------------------+
                        |   MQTT Simulator  |
                        | (CO₂, CO, Temp)  |
                        +------------------+
                                  |
                                  v
                          MQTT Broker (Mosquitto)
                                  |
                                  v
                    +-----------------------------+
                    |   Python MQTT Consumer      |
                    |   (db insert via psycopg2)  |
                    +-----------------------------+
                                  |
                                  v
                          PostgreSQL (iot DB)
                                  |
        +-------------------------+--------------------------+
        |                         |                          |
        v                         v                          v
  Raw Sensor Table       Dimension Tables         Fact Table (Incremental)
                                  |
                                  v
                       dbt Models (Dimensional & Aggregates)
                                  |
                                  v
              +----------------------------------------+
              | Airflow DAGs (ETL & Testing Pipelines) |
              +----------------------------------------+
                                  |
                                  v
               Superset / Metabase (Dashboard Layer)
```

---

## Stack Summary

| Layer              | Technology         | Description                            |
|-------------------|--------------------|----------------------------------------|
| Ingestion         | MQTT + Python      | Simulates & ingests data via Mosquitto |
| Storage           | PostgreSQL         | Raw + modeled IoT sensor data          |
| Transformation    | dbt                | Fact/dim star schema + analytics       |
| Orchestration     | Apache Airflow     | Schedules `dbt run` + `dbt test`       |
| Dashboarding      | Superset / Metabase| Visualizes trends & anomalies          |
| Environment       | Docker Compose     | Full local stack                       |

---

## Key Features

### 📊 Star Schema & Dimensional Modeling
- `fact_sensor_readings` (incremental)
- `dim_hospital`, `dim_operating_room`, `dim_sensor`, `dim_time`
- `agg_avg_sensor_by_hour`, `agg_daily_or_stats`, `anomaly_flags`, `agg_anomaly_summary`

### ⚠️ Anomaly Detection
- Detects CO₂ > 1000, CO > 10, temp <18 or >25
- Uses dbt models to flag rows and summarize daily anomaly counts

### ⏰ Scheduled DAGs
- `dbt_daily_analytics`: runs hourly/daily analytics and anomaly models
- Includes `dbt test` for model-level data validation

---

## Access

### Airflow UI:
- http://localhost:8080
- Username: `airflow`, Password: `airflow`

### Superset:
- http://localhost:8088
- Username: `admin`, Password: `admin`

### Metabase:
- http://localhost:3000

---

## How to Run

```bash
docker-compose down --volumes --remove-orphans
docker-compose up --build
```

Trigger the DAG manually or let it run on schedule. Superset and Metabase will detect the DBT models for visual analysis.

---

## Next Ideas

- Add email or Slack alerts on anomalies
- Track OR usage or surgery schedules
- Extend anomaly detection with ML models
- Publish dashboards externally via Metabase links

