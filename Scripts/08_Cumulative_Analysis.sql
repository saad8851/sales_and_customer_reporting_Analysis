-- Aggregate the data progressively over time
-- Helps to understand whether our business is growing and declining 
-- Cumulative measures by date dimensions
-- Calculate total sales per month and the running total of sales over time and moving average price
WITH cumulative AS (
SELECT 
	DATE_TRUNC('year', order_date)::date AS order_date,
	AVG(price) AS avg_price,
	SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('year', order_date)::date
)
SELECT order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	ROUND(AVG(avg_price) OVER (ORDER BY order_date), 0	) AS moving_average_price
FROM cumulative
