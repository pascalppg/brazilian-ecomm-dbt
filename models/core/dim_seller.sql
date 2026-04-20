/* Seller dimension.*/

with order_items as (
    select * from {{ ref('stg_order_items_clean') }}
),

sellers as (
    select distinct
        seller_id,
        min(processed_at) as first_seen_at,
        max(processed_at) as last_seen_at,
        count(distinct order_id) as lifetime_orders,
        count(*) as lifetime_items_sold,
        round(sum(unit_price), 2) as lifetime_revenue
    from order_items
    group by 1
)

select
    {{ dbt_utils.generate_surrogate_key(['seller_id']) }} as seller_sk,
    seller_id,
    first_seen_at,
    last_seen_at,
    lifetime_orders,
    lifetime_items_sold,
    lifetime_revenue
from sellers