import paho.mqtt.client as mqtt
import json
import psycopg2
from psycopg2.extras import execute_values

conn = psycopg2.connect(
    dbname="iot",
    user="postgres",
    password="postgres",
    host="db",
    port="5432"
)
cur = conn.cursor()

def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print(f"Failed to connect: {reason_code}.")
    else:
        print("Connected with result code " + str(reason_code))
        client.subscribe("hospital/or/env")

def on_message(client, userdata, msg):
    try:
        payload = json.loads(msg.payload.decode())
        print("Received:", payload)

        insert_query = """
            INSERT INTO sensor_readings (timestamp, hospital_id, or_id, co2_ppm, co_ppm, temperature_c)
            VALUES (%s, %s, %s, %s, %s, %s)
        """
        values = (
            payload["timestamp"],
            payload["hospital_id"],
            payload["or_id"],
            payload["co2_ppm"],
            payload["co_ppm"],
            payload["temperature_c"]
        )
        cur.execute(insert_query, values)
        conn.commit()
    except Exception as e:
        print("Error:", e)

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.on_connect = on_connect
client.on_message = on_message
client.connect("mqtt", 1883, 60)

print("🚦 Consumer listening on MQTT topic: hospital/or/env")
client.loop_forever()
