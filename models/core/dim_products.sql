with products_scd2 as (
    select * from {{ ref('int_products') }}
    where is_current = true
)
select
    product_sk,
    product_id,
    category_name,
    weight_grams,
    length_cm,
    height_cm,
    width_cm,
    volume_cm,
    photos_qty,
    valid_from,
    valid_to,
    is_current
from products_scd2