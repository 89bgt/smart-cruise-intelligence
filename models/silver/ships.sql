WITH unique_ships AS (
  SELECT DISTINCT
    TRIM(JSON_VALUE(raw_payload.cruise_data.ship_name)) as ship_name,
    LOWER(source_system) as cruise_line
  FROM {{ source('bronze', 'raw_cruise_prices') }}
  WHERE scrape_date = '2025-11-26'
    AND JSON_VALUE(raw_payload.cruise_data.ship_name) IS NOT NULL
)

SELECT
  -- Generate ship ID
  CONCAT(
    LOWER(REGEXP_REPLACE(ship_name, r'[^a-zA-Z0-9]', '')),
    '_',
    cruise_line
  ) as ship_id,
  
  ship_name,
  cruise_line

FROM unique_ships