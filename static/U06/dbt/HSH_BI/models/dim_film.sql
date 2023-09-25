SELECT DISTINCT
     [film_id]
    ,[film_title]
    ,[film_release_year]
    ,[film_language_name]
    ,[film_length]
    ,[film_category_names]
  FROM {{ ref('revenue_star_flat') }}