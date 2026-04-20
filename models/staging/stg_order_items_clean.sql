with source as (
    select * from {{ source('staging', 'order_items') }}
),
order_items_clean as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        --round standard = 2 > 0,00
        round(price, 2) as unit_price,
        round(freight_value, 2) as freight_value,
        round(price + freight_value, 2) as item_total,
        current_timestamp() as processed_at
    from source
    where order_id is not null
      and product_id is not null
)

select * from order_items_clean