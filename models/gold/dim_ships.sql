SELECT
  ship_id,
  ship_name,
  cruise_line,
  CASE 
    WHEN cruise_line = 'royal_caribbean' THEN 'premium'
    ELSE 'standard'
  END as ship_class

FROM {{ ref('ships') }}