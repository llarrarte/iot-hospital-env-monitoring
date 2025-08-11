import paho.mqtt.client as mqtt
import json
import time
import random
from datetime import datetime

broker = "mqtt"
port = 1883
topic = "hospital/or/env"



def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print(f"Failed to connect: {reason_code}.")
    else:
        print("Connected with result code " + str(reason_code))
        client.subscribe("hospital/or/env")


def on_publish(client, userdata, mid):
    print("Message published with mid: ", mid)


client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.on_connect = on_connect
client.om_publish = on_publish
client.loop_start()
client.connect(broker, port, 60)



def simulate_reading(hospital_id, or_id):
    return {
        "timestamp": datetime.utcnow().isoformat(),
        "hospital_id": hospital_id,
        "or_id": or_id,
        "co2_ppm": round(random.uniform(350, 1200), 2),
        "co_ppm": round(random.uniform(0, 15), 2),
        "temperature_c": round(random.uniform(18, 26), 2)
    }

print("🚀 Simulator started. Publishing data to MQTT...")
while True:
    for hospital in range(1, 3):
        for or_room in range(1, 4):
            msg = simulate_reading(f"H-{hospital}", f"OR-{or_room}")
            client.publish(topic, json.dumps(msg))
            print(f"Published: {msg}")
    time.sleep(2)
