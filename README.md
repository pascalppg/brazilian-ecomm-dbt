<<<<<<< HEAD
## Suggestion & Answer 
`Jika Data bertambah 100x dari Data saat ini, hal yang bisa dilakukan untuk mengoptimalkan query deteksi anomali data dari Total Revenue Daily adalah.`
`A.Snowflake`
    `1. Gunakan Auto-Suspend jika terjadi penggunaan resource yang berlebih Ketika melakukan Query Pengecekan Total Revenue Daily`
    `2. Lakukan Monitor Query profile Ketika menjalankan Data Integration & Pengecekan Total Revenue Daily`
`B.DBT`
    `1. Lakukan penyesuaian update data pada Model DQ Query Pengecekan Total Revenue Daily ke Incremental Process`
    `2. Tambahkan Filter pada Data untuk mendapatkan data New atau data changed`
    `3. Tambahkan partition FLAG_ANOMALY pada Table DQ_DAILY_REVENUE`

## Dataset
[Brazilian E-Commerce by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle.

## Models (17 total)

### Staging (RAW) (5)
- `orders` 
- `order_items`
- `customers` 
- `products` 
- `payments`

### Staging (CLEANSING & STANDARDIZE) (5)
- `stg_orders_clean` 
- `stg_order_items_clean`
- `stg_customers_clean`
- `stg_products_clean`
- `stg_payments_clean`

### Intermediate (Using SCD Type 2) (2)
- `int_customers`
- `int_products` 

### Dimensions (4)
- `dim_date`
- `dim_customers`
- `dim_product`
- `dim_seller`

### Facts (2)
- `fact_orders`
- `fact_order_payments`

### Mart (2)
- `mart_sales` — as monthly revenue by state
- `mart_customers` — as 360° customer view with segments

## Stack
- **Snowflake** —
- **dbt=1.11.8**
- **Python 3.12.7**
- **VS Code** 
- **Git + GitHub**

## Author
`Pascal Parlindungan Gultom`
=======
# brazilian-ecomm-dbt
Brazilian E-Commerce Data Warehouse using dbt and Snowflake for Technical Test
>>>>>>> 5355291489eba28023c53724185f6bc09b2243c1
