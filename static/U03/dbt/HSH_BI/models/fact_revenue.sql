SELECT
    payment_date_id,
    rental_date_id,
    return_date_id,
    film_id,
    store_id,
    store_address_id,
    customer_address_id,
    amount,
    film_rental_rate,
    rental_duration_days_actual,
    rental_duration_days_permitted
  FROM {{ ref('revenue_star_flat') }}