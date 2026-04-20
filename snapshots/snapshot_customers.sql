{% snapshot snapshot_customers %}

{{
    config(
        target_schema = 'SNAPSHOTS',
        unique_key    = 'customer_id',
        strategy      = 'timestamp',
        updated_at    = 'processed_at',
        invalidate_hard_deletes = true
    )
}}

/*
    Snapshot of data customer.
    Every time a customer's city or state changes,
    dbt will close the old record (set dbt_valid_to)
    and insert a new current record (dbt_valid_to = NULL).
    Run with: dbt snapshot
*/

select
    customer_id,
    customer_unique_id,
    zip_code_prefix,
    city,
    state_code,
    processed_at
from {{ ref('stg_customers_clean') }}

{% endsnapshot %}