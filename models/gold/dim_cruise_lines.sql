{{ config(schema='cruise_gold') }}

SELECT
  'royal_caribbean' as cruise_line_id,
  'Royal Caribbean' as cruise_line_name,
  'premium' as brand_tier,
  'large' as company_size_category,
  'family' as target_market

UNION ALL

SELECT
  'msc' as cruise_line_id,
  'MSC' as cruise_line_name,
  'budget' as brand_tier,
  'large' as company_size_category,
  'value' as target_market