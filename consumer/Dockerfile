FROM python:3.10-slim

WORKDIR /app

COPY mqtt_consumer.py .

RUN pip install paho-mqtt psycopg2-binary

CMD ["python", "mqtt_consumer.py"]
