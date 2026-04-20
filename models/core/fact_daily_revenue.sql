with orders as (

    select
        order_id,
        cast(purchased_at as date) as order_date
    from {{ ref('stg_orders_clean') }}
    where order_status = 'delivered'

),

items as (

    select
        order_id,
        unit_price,
        freight_value,
        (unit_price + freight_value) as revenue
    from {{ ref('stg_order_items_clean') }}

)

select
    o.order_date,
    sum(i.revenue) as daily_revenue,
    count(distinct o.order_id) as total_orders
from orders o
join items i on o.order_id = i.order_id
group by 1
order by 1