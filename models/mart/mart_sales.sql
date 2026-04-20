/* mart_sales.*/

with orders as (
    select * from {{ ref('fact_orders') }}
),

customers as (
    select customer_sk, customer_id, state, city
    from {{ ref('dim_customers') }}
),

dates as (
    select date_day, year, month_number, month_name, quarter, quarter_label
    from {{ ref('dim_date') }}
),

joined as (
    select
        o.order_id,
        o.order_status,
        o.purchased_at,
        o.delivered_at,
        o.is_delivered_on_time,
        o.item_count,
        o.subtotal,
        o.freight_total,
        o.order_gross_total,
        o.total_paid,
        o.primary_payment_type,
        o.max_installments,
        c.state,
        c.city,
        d.year,
        d.quarter_label,
        d.month_number,
        d.month_name
    from orders o
    left join customers c on o.customer_sk = c.customer_sk
    left join dates d on date_trunc('day', o.purchased_at) = d.date_day
    where o.order_status not in ('canceled', 'unavailable')
),

monthly_summary as (
    select
        year,
        month_number,
        month_name,
        quarter_label,
        state,
        primary_payment_type,
        count(distinct order_id) as total_orders,
        sum(item_count) as total_items,
        round(sum(order_gross_total), 2) as gross_revenue,
        round(avg(order_gross_total), 2) as avg_order_value,
        round(sum(freight_total), 2) as total_freight,
        sum(case when is_delivered_on_time then 1 else 0 end) as on_time_count,
        count(*) as delivered_count,
        round(sum(case when is_delivered_on_time then 1 else 0 end) * 100.0 / nullif(count(*), 0), 2)                                       as on_time_pct

    from joined
    group by 1, 2, 3, 4, 5, 6
)
select * from monthly_summary
order by year, month_number, state