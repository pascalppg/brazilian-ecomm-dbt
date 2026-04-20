with payments as (
    select * from {{ ref('stg_payments_clean') }}
),

orders as (
    select order_id, order_sk, customer_id, customer_sk, purchased_at
    from {{ ref('fact_orders') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['p.order_id', 'p.payment_sequential']) }} as payment_sk,
    p.order_id,
    o.order_sk,
    o.customer_id,
    o.customer_sk,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    o.purchased_at as order_purchased_at,
    p.processed_at
from payments p
left join orders o on p.order_id = o.order_id