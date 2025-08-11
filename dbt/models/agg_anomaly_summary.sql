WITH flagged AS (
    SELECT
        timestamp_id,
        hospital_id,
        or_id,
        anomaly_flag
    FROM {{ ref('anomaly_flags') }}
    WHERE anomaly_flag IS NOT NULL
)
SELECT
    DATE_TRUNC('day', timestamp_id) AS day,
    hospital_id,
    or_id,
    anomaly_flag,
    COUNT(*) AS anomaly_count
FROM flagged
GROUP BY 1, 2, 3, 4
