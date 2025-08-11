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
    *,
    CASE
        WHEN co2_ppm > 1000 THEN 'HIGH_CO2'
        WHEN co_ppm > 10 THEN 'HIGH_CO'
        WHEN temperature_c < 18 OR temperature_c > 25 THEN 'TEMP_OUT_OF_RANGE'
        ELSE NULL
    END AS anomaly_flag
FROM deduped
WHERE
    co2_ppm > 1000 OR
    co_ppm > 10 OR
    temperature_c < 18 OR temperature_c > 25
