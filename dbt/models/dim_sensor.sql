SELECT
    sensor_id,
    or_id,
    sensor_type,
    manufacturer,
    install_date
FROM {{ source('public', 'sensors') }}
