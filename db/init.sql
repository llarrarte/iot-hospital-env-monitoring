CREATE TABLE IF NOT EXISTS sensor_readings (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP,
    hospital_id VARCHAR(10),
    or_id VARCHAR(10),
    co2_ppm FLOAT,
    co_ppm FLOAT,
    temperature_c FLOAT
);

-- Hospitals
CREATE TABLE IF NOT EXISTS hospitals (
    hospital_id VARCHAR PRIMARY KEY,
    hospital_name VARCHAR,
    location VARCHAR
);

INSERT INTO hospitals (hospital_id, hospital_name, location) VALUES
('H-1', 'Saint Jude Hospital', 'New York'),
('H-2', 'Green Valley Clinic', 'San Francisco')
ON CONFLICT (hospital_id) DO NOTHING;

-- Operating Rooms
CREATE TABLE IF NOT EXISTS operating_rooms (
    or_id VARCHAR PRIMARY KEY,
    hospital_id VARCHAR REFERENCES hospitals(hospital_id),
    room_number VARCHAR,
    floor VARCHAR,
    or_type VARCHAR
);

INSERT INTO operating_rooms (or_id, hospital_id, room_number, floor, or_type) VALUES
('OR-1', 'H-1', '101', '1st', 'Cardiology'),
('OR-2', 'H-1', '102', '1st', 'Neurology'),
('OR-3', 'H-1', '201', '2nd', 'Orthopedics'),
('OR-1', 'H-2', 'A1', 'Ground', 'Pediatrics'),
('OR-2', 'H-2', 'A2', 'Ground', 'General Surgery'),
('OR-3', 'H-2', 'B1', '1st', 'Ophthalmology')
ON CONFLICT (or_id) DO NOTHING;

-- Sensors
CREATE TABLE IF NOT EXISTS sensors (
    sensor_id VARCHAR PRIMARY KEY,
    or_id VARCHAR REFERENCES operating_rooms(or_id),
    sensor_type VARCHAR,
    manufacturer VARCHAR,
    install_date DATE
);

INSERT INTO sensors (sensor_id, or_id, sensor_type, manufacturer, install_date) VALUES
('H-1_OR-1', 'OR-1', 'environment', 'SimTech', '2024-01-01'),
('H-1_OR-2', 'OR-2', 'environment', 'SimTech', '2024-01-01'),
('H-1_OR-3', 'OR-3', 'environment', 'SimTech', '2024-01-01'),
('H-2_OR-1', 'OR-1', 'environment', 'IoTMed', '2024-01-01'),
('H-2_OR-2', 'OR-2', 'environment', 'IoTMed', '2024-01-01'),
('H-2_OR-3', 'OR-3', 'environment', 'IoTMed', '2024-01-01')
ON CONFLICT (sensor_id) DO NOTHING;

CREATE DATABASE airflow_db;