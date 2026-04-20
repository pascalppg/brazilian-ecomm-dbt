with customers_scd2 as (
    select * from {{ ref('int_customers') }}
    where is_current = true 
)
select
    customer_sk,
    customer_id,
    customer_unique_id,
    zip_code,
    city,
    state,
    valid_from,
    valid_to,
    is_current
from customers_scd2