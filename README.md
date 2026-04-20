
## 💡 Scalability & Anomaly Detection — Answer

> **Pertanyaan:** Jika data bertambah **100x** dari data saat ini, hal apa yang bisa dilakukan untuk mengoptimalkan query deteksi anomali dari **Total Revenue Daily**?
> 
### A. Snowflake Optimization
#### 1. Auto-Suspend & Auto-Resume Warehouse
Gunakan **Auto-Suspend** untuk mencegah penggunaan resource yang berlebih saat menjalankan query pengecekan Total Revenue Daily.
#### 2. Monitor Query Profile
Lakukan monitoring **Query Profile** saat menjalankan Query pengecekan Total Revenue Daily.


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
