#!/bin/bash
set -e

pip install psycopg2-binary

# Setup DB
superset db upgrade

# Create admin user (safe to run multiple times)
superset fab create-admin \
    --username admin \
    --firstname Superset \
    --lastname Admin \
    --email admin@superset.com \
    --password admin || true

# Init Superset
superset init

# Import connection if YAML file exists
if [ -f "/app/superset_home/connections.yaml" ]; then
  superset import-datasources -p /app/superset_home/connections.yaml
else
  echo "Warning: connections.yaml not found. Skipping datasource import."
fi

# Start webserver
superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger
