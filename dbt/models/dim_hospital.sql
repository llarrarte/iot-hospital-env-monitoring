SELECT
    hospital_id,
    hospital_name,
    location
FROM {{ source('public', 'hospitals') }}    