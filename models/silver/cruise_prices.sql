SELECT
  -- Generate unique price ID
  GENERATE_UUID() as price_id,
  
  -- Link to cruise
  CONCAT(
    source_system, '_',
    REPLACE(CAST(JSON_VALUE(raw_payload, '$.cruise_data.sailing_date') AS STRING), '-', ''), '_',
    REGEXP_REPLACE(JSON_VALUE(raw_payload, '$.cruise_data.ship_name'), r'[^a-zA-Z0-9]', ''), '_',
    JSON_VALUE(raw_payload, '$.cruise_data.duration_nights'), 'N'
  ) as cruise_id,
  
  -- Pricing facts
  CAST(JSON_VALUE(raw_payload, '$.cruise_data.pricing.total_price') AS NUMERIC) as price_usd,
  CAST(JSON_VALUE(raw_payload, '$.cruise_data.pricing.base_price') AS NUMERIC) as base_price_usd,
  CAST(JSON_VALUE(raw_payload, '$.cruise_data.pricing.taxes_fees') AS NUMERIC) as taxes_fees_usd,
  
  -- Timing context (scrape_date is already DATE type - no parsing needed!)
  scrape_date,
  
  -- Cabin details
  LOWER(JSON_VALUE(raw_payload, '$.cruise_data.pricing.cabin_category')) as cabin_type,
  
  -- Days until departure (calculated) - FIXED DATE_DIFF
  DATE_DIFF(
    PARSE_DATE('%Y-%m-%d', JSON_VALUE(raw_payload, '$.cruise_data.sailing_date')),
    scrape_date,  -- ← Already a DATE type!
    DAY
  ) as days_to_departure,
  
  -- Metadata
  ingestion_timestamp

FROM {{ source('bronze', 'raw_cruise_prices') }}
WHERE scrape_date = '2025-11-26'