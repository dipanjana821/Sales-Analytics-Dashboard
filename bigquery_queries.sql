-- ============================================================
-- Sales Analytics Project — BigQuery Standard SQL
-- Dataset: sales_db
-- Tables:
--   sales_db.orders(order_id, order_date, order_timestamp, store_location,
--                    region, customer_id, payment_method, order_total)
--   sales_db.order_items(order_item_id, order_id, product, category,
--                         quantity, unit_price, line_total)
-- Replace `sales_db` with `your-project-id.sales_db` if querying
-- from outside the project the dataset lives in.
-- ============================================================


-- 1. TOTAL SALES
SELECT
    ROUND(SUM(order_total), 2) AS total_sales,
    COUNT(*)                    AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales_db.orders;


-- 2. AVERAGE ORDER VALUE (AOV)
SELECT
    ROUND(SUM(order_total) / COUNT(*), 2) AS avg_order_value
FROM sales_db.orders;


-- 3. REGIONAL SALES
SELECT
    region,
    ROUND(SUM(order_total), 2)           AS revenue,
    COUNT(*)                              AS orders,
    ROUND(SUM(order_total) / COUNT(*), 2) AS avg_order_value
FROM sales_db.orders
GROUP BY region
ORDER BY revenue DESC;


-- 4. MONTHLY SALES TREND
SELECT
    FORMAT_DATE('%Y-%m', order_date) AS month,
    ROUND(SUM(order_total), 2)        AS revenue,
    COUNT(*)                          AS orders
FROM sales_db.orders
GROUP BY month
ORDER BY month;


-- 5. TOP-SELLING PRODUCTS (by revenue)
SELECT
    product,
    category,
    SUM(quantity)             AS units_sold,
    ROUND(SUM(line_total), 2) AS revenue
FROM sales_db.order_items
GROUP BY product, category
ORDER BY revenue DESC
LIMIT 10;


-- 6. SALES BY CATEGORY
SELECT
    category,
    ROUND(SUM(line_total), 2) AS revenue,
    SUM(quantity)              AS units_sold,
    ROUND(100 * SUM(line_total) / SUM(SUM(line_total)) OVER (), 1) AS pct_of_total
FROM sales_db.order_items
GROUP BY category
ORDER BY revenue DESC;


-- 7. SALES BY STORE LOCATION
SELECT
    store_location,
    region,
    ROUND(SUM(order_total), 2) AS revenue,
    COUNT(*)                    AS orders
FROM sales_db.orders
GROUP BY store_location, region
ORDER BY revenue DESC;


-- 8. PAYMENT METHOD MIX
SELECT
    payment_method,
    COUNT(*)                    AS orders,
    ROUND(SUM(order_total), 2)  AS revenue,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_orders
FROM sales_db.orders
GROUP BY payment_method
ORDER BY revenue DESC;


-- 9. WEEKDAY VS WEEKEND PERFORMANCE
SELECT
    CASE WHEN EXTRACT(DAYOFWEEK FROM order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    ROUND(SUM(order_total), 2)                               AS revenue,
    ROUND(SUM(order_total) / COUNT(DISTINCT order_date), 2)  AS avg_daily_revenue
FROM sales_db.orders
GROUP BY day_type;


-- 10. MONTH-OVER-MONTH GROWTH
WITH monthly AS (
    SELECT FORMAT_DATE('%Y-%m', order_date) AS month,
           SUM(order_total) AS revenue
    FROM sales_db.orders
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;
