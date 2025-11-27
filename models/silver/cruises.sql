-- models/silver/cruises.sql

SELECT
  -- Generate unique cruise identifier
  CONCAT(
    source_system, '_',
    REPLACE(CAST(JSON_VALUE(raw_payload.cruise_data.sailing_date) AS STRING), '-', ''), '_',
    REGEXP_REPLACE(JSON_VALUE(raw_payload.cruise_data.ship_name), r'[^a-zA-Z0-9]', ''), '_',
    JSON_VALUE(raw_payload.cruise_data.duration_nights), 'N'
  ) as cruise_id,
  
  -- Clean and standardize cruise line
  LOWER(source_system) as cruise_line,
  
  -- Clean ship name
  TRIM(JSON_VALUE(raw_payload.cruise_data.ship_name)) as ship_name,
  
  -- Route information
  TRIM(JSON_VALUE(raw_payload.cruise_data.itinerary.route_name)) as route_name,
  TRIM(JSON_VALUE(raw_payload.cruise_data.itinerary.region)) as route_category,
  
  -- Departure details
  TRIM(JSON_VALUE(raw_payload.cruise_data.departure_port)) as departure_port,
  
  -- Sailing dates
  PARSE_DATE('%Y-%m-%d', JSON_VALUE(raw_payload.cruise_data.sailing_date)) as sailing_date,
  CAST(JSON_VALUE(raw_payload.cruise_data.duration_nights) AS INT64) as duration_days,
  
  -- Metadata
  source_system as data_source,
  ingestion_timestamp

FROM {{ ref('raw_cruise_prices') }}
-- WHERE scrape_date = CURRENT_DATE()  -- Only process recent data