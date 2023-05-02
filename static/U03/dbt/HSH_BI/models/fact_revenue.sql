SELECT
    payment_date_id,
    rental_date_id,
    return_date_id,
    film_id,
    store_id,
    store_address_id,
    customer_address_id,
    payment_date,
    rental_date,
    return_date,
    amount,
    rental_duration_days
  FROM {{ ref('revenue_star_flat') }}