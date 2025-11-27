WITH unique_routes AS (
  SELECT DISTINCT
    TRIM(JSON_VALUE(raw_payload.cruise_data.itinerary.route_name)) as route_name,
    TRIM(JSON_VALUE(raw_payload.cruise_data.itinerary.region)) as route_category,
    TRIM(JSON_VALUE(raw_payload.cruise_data.departure_port)) as departure_port,
    CAST(JSON_VALUE(raw_payload.cruise_data.duration_nights) AS INT64) as typical_duration_days
  FROM {{ source('bronze', 'raw_cruise_prices') }}
  WHERE scrape_date = '2025-11-26'
    AND JSON_VALUE(raw_payload.cruise_data.itinerary.route_name) IS NOT NULL
)

SELECT
  -- Generate route ID
  CONCAT(
    LOWER(REGEXP_REPLACE(route_name, r'[^a-zA-Z0-9]', '')),
    '_',
    LOWER(REGEXP_REPLACE(route_category, r'[^a-zA-Z0-9]', ''))
  ) as route_id,
  
  route_name,
  route_category,
  departure_port,
  typical_duration_days

FROM unique_routes