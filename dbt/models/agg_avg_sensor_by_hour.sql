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
    DATE_TRUNC('hour', timestamp_id) AS hour,
    hospital_id,
    or_id,
    AVG(co2_ppm) AS avg_co2,
    AVG(co_ppm) AS avg_co,
    AVG(temperature_c) AS avg_temp
FROM deduped
GROUP BY 1, 2, 3
