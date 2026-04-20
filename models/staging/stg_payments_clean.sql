with source as (
    select * from {{ source('staging', 'payments') }}
),

payments_clean as (
    select
        order_id,
        payment_sequential,
        lower(trim(payment_type)) as payment_type,
        payment_installments,
        round(payment_value, 2) as payment_value,
        current_timestamp() as processed_at
    from source
    where order_id is not null
)

select * from payments_clean