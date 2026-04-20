with base as (
    select *
    from {{ ref('fact_daily_revenue') }}
),

w_data as (
    select
        a.order_date,
        a.daily_revenue,
        b.order_date as hist_date,
        b.daily_revenue as hist_revenue
    from base a
    join base b
        on b.order_date between dateadd(day, -30, a.order_date)
                           and dateadd(day, -1, a.order_date)

),

median_calc as (
    select
        order_date,
        daily_revenue,
        percentile_cont(0.5)
        within group (order by hist_revenue) as rolling_median
    from w_data
    group by order_date, daily_revenue

),

deviation_data as (
    select
        w.order_date,
        w.daily_revenue,
        m.rolling_median,
        abs(w.hist_revenue - m.rolling_median) as abs_dev
    from w_data w
    join median_calc m
        on w.order_date = m.order_date
),

mad_calc as (
    select
        order_date,
        daily_revenue,
        rolling_median,
        percentile_cont(0.5)
        within group (order by abs_dev) as mad_value
    from deviation_data
    group by order_date, daily_revenue, rolling_median

),

dq_final as (
    select
        order_date,
        daily_revenue,
        rolling_median,
        mad_value,
        case
            when mad_value = 0 or mad_value is null then 0
            else 0.6745 * (daily_revenue - rolling_median) / mad_value
        end as robust_score,
        case
            when abs(
                case
                    when mad_value = 0 or mad_value is null then 0
                    else 0.6745 * (daily_revenue - rolling_median) / mad_value
                end
            ) > 3.5
            then 'Anomaly'
            else 'Normal'
        end as flag_anomaly
    from mad_calc
)
select *
from dq_final
order by order_date