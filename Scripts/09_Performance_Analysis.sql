-- Compare the current value to a target value 
-- Helps to measure the success to compare the performance 
-- Current[Measure] - Target[Measure]
/* Task -> Analyze the yearly performance of products by comparing each product's sales 
   to both its average sales performance and the previous's year sales. */
WITH yearly_products_sales AS (
SELECT 
	EXTRACT(YEAR FROM f.order_date) AS order_year,
	p.product_name,
	SUM(f.sales_amount) AS current_sales
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key = p.product_key
GROUP BY
	EXTRACT(YEAR FROM f.order_date), p.product_name 
)
SELECT 
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_sales,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_sales,
    CASE 
        WHEN current_sales -  LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales -  LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS prev_change
FROM yearly_products_sales


