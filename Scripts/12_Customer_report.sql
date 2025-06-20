/* Customer Report
Purpose
   - This report consolidates KEY customer metrices AND behaviour

Highlights :
   1. Gathers essential fields such AS names, ages AND TRANSACTION details.
   2. Segments customers INTO categories (VIP, Regular, New) AND age GROUPS.
   3. Aggregates customer-LEVEL metrices:
      - total orders
      - total sales
      - total quantity purchased
      - total products
      - lifespan (in months)
   4. Calculate valuable KPIs :
      - recency (month since last orders)
      - average order value 
      - average monthly spend
 */
CREATE VIEW report_customers AS 
WITH base_query AS (
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	EXTRACT (YEAR FROM AGE(current_date, c.birthdate)) AS age_yrs
FROM fact_sales f
LEFT JOIN dim_customers c ON c.customer_key = f.customer_key 
WHERE order_date IS NOT NULL
), customer_insights AS (
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age_yrs,
	MAX(order_date) AS last_order,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	EXTRACT( YEARS FROM AGE(MAX(order_date), MIN(order_date))) *12 +
	EXTRACT( MONTHS FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age_yrs 
)
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age_yrs,
	CASE WHEN age_yrs <20 THEN 'UNDER 20'
		 WHEN age_yrs BETWEEN 20 AND 29 THEN '20-29'
		 WHEN age_yrs BETWEEN 30 AND 39 THEN '30-39'
		 WHEN age_yrs BETWEEN 40 AND 49 THEN '40-49'
		 ELSE 'ABOVE 50'
	END AS age_group,
	CASE WHEN lifespan>= 12 AND total_sales > 5000 THEN 'VIP'
         WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
         ELSE 'NEW '
    END AS customer_type,
    last_order,
    EXTRACT (YEARS FROM AGE(current_date, last_order)) *12 +
    EXTRACT (MONTHS FROM AGE(current_date, last_order)) AS recency,
	total_orders,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
	END AS avg_order_value,
	ROUND(CASE WHEN lifespan = 0 THEN 0
		 ELSE total_sales / lifespan 
	END , 2 ) AS avg_monthly_spend,
	total_sales,
	total_quantity,
	total_products
FROM customer_insights










