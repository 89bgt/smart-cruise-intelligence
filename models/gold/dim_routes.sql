SELECT
  route_id,
  route_name,
  route_category,
  departure_port,
  typical_duration_days,
  CASE 
    WHEN route_category = 'caribbean' THEN 'High'
    WHEN route_category = 'mediterranean' THEN 'Medium'
    ELSE 'Low'
  END as popularity_tier

FROM {{ ref('routes') }}