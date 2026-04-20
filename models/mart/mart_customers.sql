/*mart_customers — 360-degree customer view.*/
with customers_360 as (
    select * from {{ ref('dim_customers') }}
),

orders as (
    select * from {{ ref('fact_orders') }}
    where order_status not in ('canceled', 'unavailable')
),

customer_orders as (
    select
        customer_id,
        count(distinct order_id) as total_orders,
        min(purchased_at) as first_order_at,
        max(purchased_at) as last_order_at,
        datediff('day', min(purchased_at),max(purchased_at)) as customer_tenure_days,
        round(sum(order_gross_total), 2) as lifetime_value,
        round(avg(order_gross_total), 2) as avg_order_value,
        round(sum(freight_total), 2) as total_freight_paid,
        sum(item_count) as total_items_purchased,
        round(avg(item_count), 1) as avg_items_per_order,
        sum(case when is_delivered_on_time then 1 else 0 end) as on_time_deliveries,
        max(primary_payment_type) as most_used_payment_type
    from orders
    group by 1
),

segmented as (
    select
        c.customer_sk,
        c.customer_id,
        c.customer_unique_id,
        c.zip_code,
        c.city,
        c.state,
        coalesce(o.total_orders, 0) as total_orders,
        coalesce(o.lifetime_value, 0) as lifetime_value,
        coalesce(o.avg_order_value, 0) as avg_order_value,
        coalesce(o.total_freight_paid, 0) as total_freight_paid,
        coalesce(o.total_items_purchased, 0) as total_items_purchased,
        coalesce(o.avg_items_per_order, 0) as avg_items_per_order,
        o.first_order_at,
        o.last_order_at,
        coalesce(o.on_time_deliveries, 0) as on_time_deliveries,
        o.most_used_payment_type,
        case
            when o.total_orders is null         then 'no_orders'
            when o.total_orders = 1             then 'one_time'
            when o.total_orders between 2 and 4 then 'repeat'
            when o.total_orders >= 5            then 'loyal'
        end as order_frequency_segment,

        case
            when coalesce(o.lifetime_value, 0) = 0      then 'no_spend'
            when o.lifetime_value < 100                  then 'low_value'
            when o.lifetime_value between 100 and 500    then 'mid_value'
            when o.lifetime_value > 500                  then 'high_value'
        end as value_segment
        
    from customers_360 c
    left join customer_orders o on c.customer_id = o.customer_id
)

select * from segmented