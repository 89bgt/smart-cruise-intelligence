SELECT
  'early' as booking_window_id,
  'early' as window_category,
  181 as min_days_to_departure,
  365 as max_days_to_departure,
  'Book 6+ months in advance' as description,
  1 as recommendation_priority

UNION ALL

SELECT
  'standard' as booking_window_id,
  'standard' as window_category,
  61 as min_days_to_departure,
  180 as max_days_to_departure,
  'Book 2-6 months in advance' as description,
  2 as recommendation_priority

UNION ALL

SELECT
  'last_minute' as booking_window_id,
  'last_minute' as window_category,
  0 as min_days_to_departure,
  60 as max_days_to_departure,
  'Last-minute bookings (< 2 months)' as description,
  3 as recommendation_priority