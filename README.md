# Sales Analytics Dashboard

Order-level sales analytics project built using Google BigQuery, Google Sheets, and Power BI.

## Stack
- **Google BigQuery** — data warehouse, SQL analysis
- **Google Sheets (Connected Sheets)** — live summary view
- **Power BI** — dashboard, DAX measures

## Data
- `orders.csv` — 5,248 orders across 5 store locations and 4 regions, Jan–Jul 2026
- `order_items.csv` — 9,852 line items, joined to orders on `order_id`

## SQL analysis
See [`bigquery_queries.sql`](bigquery_queries.sql) for the full set of queries, including:
- Total sales, average order value, unique customers
- Regional and monthly revenue breakdowns
- Top-selling products by revenue
- Month-over-month growth using a `LAG()` window function

## Dashboard
Dashboard screenshot (Sales Tracker Dashboard.png)
<img width="594" height="335" alt="Sales Tracker Dashboard" src="https://github.com/user-attachments/assets/2e9d0551-058d-4e15-bb77-3f40c0f13363" />

Built in Power BI with DAX measures for Total Sales, AOV, and Unique Customers,
connected live to BigQuery. Includes monthly trend, regional distribution,
top products, and category breakdown visuals.

