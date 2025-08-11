WITH ranked_readings AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY timestamp_id, hospital_id, or_id, sensor_id
               ORDER BY timestamp_id
           ) AS row_num
    FROM {{ ref('fact_sensor_readings') }}
),
deduped AS (
    SELECT *
    FROM ranked_readings
    WHERE row_num = 1
)
SELECT
    DATE(timestamp_id) AS day,
    hospital_id,
    or_id,
    MAX(co2_ppm) AS max_co2,
    MIN(co2_ppm) AS min_co2,
    MAX(temperature_c) AS max_temp,
    MIN(temperature_c) AS min_temp
FROM deduped
GROUP BY 1, 2, 3
