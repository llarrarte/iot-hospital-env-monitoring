SELECT
    full_ts AS timestamp_id,
    full_ts,
    DATE(full_ts) AS date,
    EXTRACT(HOUR FROM full_ts) AS hour,
    TO_CHAR(full_ts, 'Day') AS day_name,
    CASE WHEN EXTRACT(ISODOW FROM full_ts) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend
FROM (
    SELECT DISTINCT
        timestamp::timestamp AS full_ts
    FROM {{ source('public', 'sensor_readings') }}
) AS raw_timestamps
