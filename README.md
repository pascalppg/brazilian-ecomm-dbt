<img width="208" height="49" alt="image" src="https://github.com/user-attachments/assets/59f5c757-001c-4d43-9b9e-865a4ea83ab5" />
## Anomaly Detection Total Revenue Answer — Answer

> **Pertanyaan:** Jika data bertambah **100x** dari data saat ini, hal apa yang bisa dilakukan untuk mengoptimalkan query deteksi anomali dari **Total Revenue Daily**?
> 
### A. Snowflake Optimization
#### 1. Lakukan **Auto-Suspend** untuk mencegah penggunaan resource yang berlebih saat menjalankan query pengecekan Total Revenue Daily.
#### 2. Lakukan monitoring **Query Profile** saat menjalankan Query pengecekan Total Revenue Daily.

### B. DBT Optimization
#### 1. Lakukan penyesuaian update data pada Model DQ Query Pengecekan Total Revenue Daily ke Incremental Process
#### 2. Tambahkan Filter pada Data untuk mendapatkan data New atau data changed
#### 3. Tambahkan partition FLAG_ANOMALY pada Table DQ_DAILY_REVENUE


## Dataset
[Brazilian E-Commerce by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle.

## Models (17 total)

### Staging (Cleansing & Standardize) (5)
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
- `Fact_daily_revenue`
  
### Mart (2)
- `mart_sales` — as monthly revenue by state
- `mart_customers` — as 360° customer view with segments
- `dq_daily_revenue` — as Check Anomaly Total Revenue Daily

## Stack
- **Snowflake**
- **dbt=1.11.8**
- **Python 3.12.7**
- **VS Code** 
- **Git + GitHub**

## Author
`Pascal Parlindungan Gultom`
=======
