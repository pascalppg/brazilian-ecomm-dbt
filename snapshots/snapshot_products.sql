{% snapshot snapshot_products %}

{{
    config(
        target_schema = 'SNAPSHOTS',
        unique_key    = 'product_id',
        strategy      = 'timestamp',
        updated_at    = 'processed_at',
        invalidate_hard_deletes = true
    )
}}

/*
    Snapshot of stg_products.
    Tracks changes in category_name, weight, and dimensions over time.

    Run with: dbt snapshot
*/

select
    product_id,
    category_name,
    weight_grams,
    length_cm,
    height_cm,
    width_cm,
    volume_cm3,
    photos_qty,
    processed_at

from {{ ref('stg_products_clean') }}

{% endsnapshot %}