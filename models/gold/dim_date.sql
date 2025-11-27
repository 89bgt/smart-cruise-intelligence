{{ config(schema='cruise_gold') }}

SELECT
  FORMAT_DATE('%Y%m%d', date_val) as date_id,
  date_val as full_date,
  EXTRACT(DAY FROM date_val) as day_number,
  FORMAT_DATE('%A', date_val) as day_name,
  EXTRACT(MONTH FROM date_val) as month_number,
  FORMAT_DATE('%B', date_val) as month_name,
  EXTRACT(QUARTER FROM date_val) as quarter_number,
  CONCAT('Q', EXTRACT(QUARTER FROM date_val)) as quarter_name,
  EXTRACT(YEAR FROM date_val) as year_number,
  CASE 
    WHEN EXTRACT(MONTH FROM date_val) IN (12, 1, 2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM date_val) IN (3, 4, 5) THEN 'Spring'
    WHEN EXTRACT(MONTH FROM date_val) IN (6, 7, 8) THEN 'Summer'
    ELSE 'Fall'
  END as season,
  CASE 
    WHEN FORMAT_DATE('%A', date_val) IN ('Saturday', 'Sunday') THEN TRUE
    ELSE FALSE
  END as is_weekend,
  FALSE as is_holiday,
  CASE 
    WHEN EXTRACT(MONTH FROM date_val) IN (6, 7, 8, 12) THEN 'Peak'
    WHEN EXTRACT(MONTH FROM date_val) IN (1, 2, 9, 10) THEN 'Shoulder'
    ELSE 'Off-Peak'
  END as sailing_season

FROM UNNEST(GENERATE_DATE_ARRAY(DATE('2024-01-01'), DATE('2028-12-31'), INTERVAL 1 DAY)) as date_val