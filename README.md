
# 📊 sales_and_customer_reporting_Analysis

This repository contains a series of optimized and structured SQL scripts aimed at analyzing business performance across multiple dimensions including customer behavior, product performance, sales trends, and more.

Each SQL script serves a specific analytical purpose and leverages advanced SQL functions like window functions, CTEs, and conditional logic to derive meaningful insights from raw transactional data.

---

## 📁 Repository Structure

### 1. `06_ranking_analysis.sql`
**Purpose:** Rank products and customers based on performance metrics.
- Top 5 and bottom 5 products by revenue.
- Top 10 customers by revenue.
- Customers with the fewest orders.
- Uses: `RANK()`, `ROW_NUMBER()`, `GROUP BY`, `ORDER BY`.

### 2. `07_Change_overTime.sql`
**Purpose:** Analyze how sales and customer metrics evolve over time.
- Monthly aggregation of total sales, customer count, and quantity.
- Uses: `DATE_TRUNC()`, `GROUP BY` on time.

### 3. `08_Cumulative_Analysis.sql`
**Purpose:** Analyze cumulative trends over time.
- Running total of sales and moving average price by year.
- Uses: `WINDOW FUNCTIONS`, `WITH CTE`.

### 4. `09_Performance_Analysis.sql`
**Purpose:** Compare product sales to their historical average and prior year.
- Classifies each product's performance relative to historical average.
- Identifies YoY increases/decreases.
- Uses: `LAG()`, `AVG() OVER`, `CASE`.

### 5. `10_DataSegmentation.sql`
**Purpose:** Segment customers and products for strategic targeting.
- Segments products by cost ranges.
- Segments customers into VIP, Regular, or New based on tenure and spend.
- Uses: `CASE`, `EXTRACT()`, `AGE()`.

### 6. `11_PartToWhole_Analysis.sql`
**Purpose:** Understand part-to-whole relationships.
- Calculates each category’s share of overall sales.
- Uses: `SUM() OVER()`, `TO_CHAR()` for percentage formatting.

### 7. `12_Customer_report.sql`
**Purpose:** Generate a comprehensive customer report.
- KPIs: lifespan, recency, AOV, average monthly spend.
- Segments by age group and customer type.
- Creates: `VIEW report_customers`.

### 8. `13_Product_report.sql`
**Purpose:** Generate a comprehensive product report.
- KPIs: lifespan, recency, AOR, average monthly revenue.
- Segments by performance tier (High, Mid, Low).
- Creates: `VIEW report_products`.

---

## 🛠 Requirements
These scripts assume a star schema-like database with the following tables:
- `fact_sales`
- `dim_products`
- `dim_customers`

Ensure your data conforms to expected field names such as `sales_amount`, `order_date`, `product_key`, `customer_key`, etc.

---

## 🚀 Getting Started

1. Clone this repository.
2. Load the SQL scripts into your preferred SQL client (e.g., pgAdmin, DBeaver).
3. Run them in the suggested order or as needed.
4. Adjust table or field names based on your database schema.

---

## 📌 Notes

- Most scripts are designed with PostgreSQL syntax. Adaptations might be required for other databases (e.g., MySQL, SQL Server).
- Window functions are extensively used for ranking, trend, and performance analysis.

---

## 🧠 License

MIT License — feel free to use, modify, and distribute with attribution.

---

## 🙌 Contributions

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.


