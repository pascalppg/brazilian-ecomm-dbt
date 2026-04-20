/*
  SCD Type 2 for products.
  Tracks changes in category name and measurements over time.
*/

with products as (
    select * from {{ ref('stg_products_clean') }}
),

products_scd2 as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_sk,
        product_id,
        category_name,
        weight_grams,
        length_cm,
        height_cm,
        width_cm,
        volume_cm,
        name_length,
        description_length,
        photos_qty,
        processed_at as valid_from,
        cast(NULL as timestamp_ntz) as valid_to,
        true as is_current,
        processed_at
    from products
)

select * from products_scd2