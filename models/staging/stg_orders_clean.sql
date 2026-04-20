with source as (
    select * from {{ source('staging', 'orders') }}
),

orders_clean as (
    select
        order_id,
        customer_id,
        lower(trim(order_status)) as order_status,
        order_purchase_timestamp as purchased_at,
        order_approved_at as approved_at,
        order_delivered_carrier_date as shipped_at,
        order_delivered_customer_date as delivered_at,
        order_estimated_delivery_date as estimated_delivery_at,
        case
            when order_delivered_customer_date is null then false
            when order_delivered_customer_date <= order_estimated_delivery_date then true
            else false
        end as is_delivered_on_time,
        current_timestamp() processed_at
    from source
    where order_id is not null
)

select * from orders_clean