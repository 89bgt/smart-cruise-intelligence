SELECT
  'interior' as cabin_type_id,
  'interior' as cabin_category,
  'standard' as cabin_subcategory,
  150 as typical_size_sqft,
  4 as max_occupancy,
  'basic' as amenity_level

UNION ALL

SELECT
  'ocean_view' as cabin_type_id,
  'ocean_view' as cabin_category,
  'standard' as cabin_subcategory,
  180 as typical_size_sqft,
  4 as max_occupancy,
  'enhanced' as amenity_level

UNION ALL

SELECT
  'balcony' as cabin_type_id,
  'balcony' as cabin_category,
  'standard' as cabin_subcategory,
  220 as typical_size_sqft,
  4 as max_occupancy,
  'premium' as amenity_level