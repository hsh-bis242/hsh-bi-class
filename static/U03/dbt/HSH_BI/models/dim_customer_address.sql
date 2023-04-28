SELECT DISTINCT
     [customer_address_id]
    ,[customer_city_name]
    ,[customer_country_name]
    ,[customer_district_name]
  FROM {{ ref('revenue_star_flat') }}