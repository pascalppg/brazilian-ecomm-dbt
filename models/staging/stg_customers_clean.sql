with source as (
    select * from {{ source('staging', 'customers') }}
),

customers_clean as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix as zip_code,
        upper(customer_city) as city,
        upper(customer_state) as state,
        current_timestamp() as processed_at
    from source
)

select * from customers_clean