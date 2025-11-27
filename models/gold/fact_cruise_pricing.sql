WITH price_data AS (
  SELECT
    cp.price_id,
    cp.cruise_id,
    cp.price_usd,
    cp.base_price_usd,
    cp.taxes_fees_usd,
    cp.scrape_date,
    cp.days_to_departure,
    cp.cabin_type,
    cp.ingestion_timestamp,
    
    c.cruise_line,
    c.ship_name,
    c.sailing_date,
    c.route_name,
    c.route_category,
    c.departure_port
    
  FROM {{ ref('cruise_prices') }} cp
  JOIN {{ ref('cruises') }} c ON cp.cruise_id = c.cruise_id
),

enriched_data AS (
  SELECT
    pd.*,
    r.route_id,
    s.ship_id,
    CASE 
      WHEN pd.days_to_departure > 180 THEN 'early'
      WHEN pd.days_to_departure BETWEEN 61 AND 180 THEN 'standard'
      ELSE 'last_minute'
    END as booking_window_category
    
  FROM price_data pd
  LEFT JOIN {{ ref('routes') }} r 
    ON r.route_name = pd.route_name 
    AND r.route_category = pd.route_category
  LEFT JOIN {{ ref('ships') }} s 
    ON s.ship_name = pd.ship_name 
    AND s.cruise_line = pd.cruise_line
  WHERE pd.sailing_date IS NOT NULL
    AND pd.price_usd IS NOT NULL
)

SELECT
  GENERATE_UUID() as fact_id,
  
  -- Foreign Keys
  FORMAT_DATE('%Y%m%d', sailing_date) as date_id,
  route_id,
  cruise_line as cruise_line_id,
  ship_id,
  booking_window_category as booking_window_id,
  FORMAT_DATE('%Y%m%d', scrape_date) as scrape_date_id,
  cabin_type as cabin_type_id,
  
  -- Measures
  price_usd,
  base_price_usd,
  taxes_fees_usd,
  days_to_departure,
  1 as cabin_availability_count,  -- Default for MVP
  
  -- Degenerate Dimensions
  price_id as scraping_batch_id,
  cruise_line as source_system

FROM enriched_data