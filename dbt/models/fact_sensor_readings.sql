{{ config(
    materialized='incremental',
    unique_key=['timestamp_id', 'hospital_id', 'or_id', 'sensor_id'],
    on_schema_change='ignore'
) }}
WITH base AS (
    SELECT
        timestamp::timestamp AS full_ts,
        hospital_id,
        or_id,
        CONCAT(hospital_id, '_', or_id) AS sensor_id,
        co2_ppm,
        co_ppm,
        temperature_c
    FROM {{ source('public', 'sensor_readings') }}
    {% if is_incremental() %}
        WHERE timestamp > (SELECT MAX(timestamp_id) FROM {{ this }})
    {% endif %}
)
SELECT
    full_ts AS timestamp_id,
    hospital_id,
    or_id,
    sensor_id,
    co2_ppm,
    co_ppm,
    temperature_c
FROM base
