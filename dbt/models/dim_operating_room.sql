SELECT
    or_id,
    hospital_id,
    room_number,
    floor,
    or_type
FROM {{ source('public', 'operating_rooms') }}
