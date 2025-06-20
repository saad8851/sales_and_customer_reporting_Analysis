-- Total products by sales range 
-- Total customers by Age 
/* Task 1 - Segments products INTO COST ranges AND count how many products falls INTO EACH segments */


SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM (
SELECT 
	product_key,
	product_name,
	COST,
	CASE WHEN COST <100 THEN 'Below 100'
	     WHEN COST BETWEEN 100 AND 500 THEN 'Between 100-500'
	     WHEN COST BETWEEN 500 AND 1000 THEN '500-1000'
	     ELSE 'Above 1000'
	END AS cost_range
FROM dim_products ) AS product_segments
GROUP BY cost_range 
ORDER BY total_products ASC



/* Task 2 - Group Customers into three segments based on their spending behaviour:
   1. VIP : atleast 12 months of history and spending more than 5,000
   2. REGULAR : atleast 12 months of history but spending 5,000 or less
   3. NEW : lifespan less than 12 months
   AND find the total customers by each group 
 */


WITH customer_segments AS (
SELECT 
	c.customer_key,
	SUM(f.sales_amount) AS total_spending,
	MIN(f.order_date) AS first_order_date,
	MAX(f.order_date) AS last_order_date,
	EXTRACT(YEAR FROM AGE(MAX(f.order_date), MIN(f.order_date))) *12 +
	EXTRACT(MONTH FROM AGE(MAX(f.order_date), MIN(f.order_date))) AS active_months
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key 
GROUP BY c.customer_key
),
type_segments AS (
SELECT 
	customer_key,
	CASE WHEN active_months >= 12 AND total_spending > 5000 THEN 'VIP'
         WHEN active_months >= 12 AND total_spending <= 5000 THEN 'REGULAR'
         ELSE 'NEW '
    END AS customer_type
FROM customer_segments 
)
SELECT
	customer_type,
	COUNT( customer_key) AS total_custumers
FROM type_segments
GROUP BY customer_type
ORDER BY total_custumers











