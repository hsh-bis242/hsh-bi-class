SELECT DISTINCT
     [store_address_id]
    ,[store_city_name]
    ,[store_country_name]
    ,[store_district_name]
  FROM {{ ref('revenue_star_flat') }}