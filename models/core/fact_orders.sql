with orders as (
    select * from {{ ref('stg_orders_clean') }}
),

order_items_agg as (
    select
        order_id,
        count(*)  as item_count,
        count(distinct product_id) as unique_products,
        count(distinct seller_id) as unique_sellers,
        round(sum(unit_price), 2) as subtotal,
        round(sum(freight_value), 2) as freight_total,
        round(sum(item_total), 2) as order_gross_total
    from {{ ref('stg_order_items_clean') }}
    group by 1
),

payments_agg as (
    select
        order_id,
        round(sum(payment_value), 2)            as total_paid,
        max(payment_type)                       as primary_payment_type,
        max(payment_installments)               as max_installments,
        count(*)                                as payment_count
    from {{ ref('stg_payments_clean') }}
    group by 1
),

customers as (
    select customer_id, customer_sk
    from {{ ref('dim_customers') }}
),

dates as (
    select date_day, date_key
    from {{ ref('dim_date') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['o.order_id']) }} as order_sk,
    o.order_id,
    o.customer_id,
    c.customer_sk,
    d_purchase.date_key as purchase_date_key,
    d_deliver.date_key as delivery_date_key,
    o.order_status,
    o.purchased_at,
    o.approved_at,
    o.shipped_at,
    o.delivered_at,
    o.estimated_delivery_at,
    o.is_delivered_on_time,
    coalesce(i.item_count, 0) as item_count,
    coalesce(i.unique_products, 0) as unique_products,
    coalesce(i.unique_sellers, 0) as unique_sellers,
    coalesce(i.subtotal, 0) as subtotal,
    coalesce(i.freight_total, 0) as freight_total,
    coalesce(i.order_gross_total, 0) as order_gross_total,
    coalesce(p.total_paid, 0) as total_paid,
    p.primary_payment_type,
    p.max_installments,
    coalesce(p.payment_count, 1) as payment_count,
    o.processed_at
from orders o
left join order_items_agg i on o.order_id = i.order_id
left join payments_agg p on o.order_id = p.order_id
left join customers c on o.customer_id = c.customer_id
left join dates d_purchase on date_trunc('day', o.purchased_at) = d_purchase.date_day
left join dates d_deliver  on date_trunc('day', o.delivered_at) = d_deliver.date_day