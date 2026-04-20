/*SCD Type 2 for customers data to dim_customers.*/

with customers as (
    select * from {{ ref('stg_customers_clean') }}
),

/*Add surrogate key + SCD2 validity columns.replace with a {{ ref('snapshot_customers') }} */

customers_scd2 as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_sk,
        customer_id,
        customer_unique_id,
        zip_code,
        city,
        state,
        processed_at as valid_from,
        cast(NULL as timestamp_ntz) as valid_to,
        true as is_current,
        processed_at
    from customers
)

select * from customers_scd2