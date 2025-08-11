FROM apache/superset:latest

# Install required Python package using the existing 'superset' user
USER superset

# Install PostgreSQL driver for SQLAlchemy
RUN pip install --no-cache-dir psycopg2-binary
