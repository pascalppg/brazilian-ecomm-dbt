/*Date dimension — generates one row per day from 2016-01-01 to 2026-12-31*/

with date_spine as (
    select
        dateadd(
            day,
            seq4(),
            '2016-01-01'::date
        ) as date_day
    from table(generator(rowcount => 3987))     
),

date_enriched as (
    select
        date_day,
        to_number(to_char(date_day, 'YYYYMMDD')) as date_key,
        year(date_day) as year,
        quarter(date_day) as quarter,
        month(date_day) as month_number,
        monthname(date_day) as month_name,
        weekofyear(date_day) as week_of_year,
        dayofweek(date_day) as day_of_week,     
        dayname(date_day) as day_name,
        dayofmonth(date_day) as day_of_month,
        dayofyear(date_day) as day_of_year,
        case when dayofweek(date_day) in (0, 6)
            then true 
            else false
        end as is_weekend,
        'Q' || quarter(date_day) || '-' || year(date_day) as quarter_label,
        date_trunc('month', date_day) as first_day_of_month,
        date_trunc('week',  date_day) as first_day_of_week
    from date_spine
)

select * from date_enriched