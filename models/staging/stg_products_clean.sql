with source as (
    select * from {{ source('staging', 'products') }}
),
products_clean as (
    select
        product_id,
        coalesce(lower(trim(product_category_name)),'unknown') as category_name,
        product_name_length as name_length,
        product_description_length as description_length,
        product_photos_qty as photos_qty,
        product_weight_g as weight_grams,
        product_length_cm as length_cm,
        product_height_cm as height_cm,
        product_width_cm as width_cm,
        ---product_length_cm*product_height_cm*product_width_cm = find volume
        round(product_length_cm * product_height_cm * product_width_cm, 2) as volume_cm,
        current_timestamp() as processed_at
    from source
    where product_id is not null
)
select * from products_clean