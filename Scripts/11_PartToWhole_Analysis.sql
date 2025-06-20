/* Analyze how an individual part(sales) is performing compared to the overall,
   allowing us to understand which category has the greatest impact on the buisness 
*/
WITH category_sales AS (
SELECT 
	p.category,
	SUM(f.sales_amount) AS total_sales
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key = p.product_key
GROUP BY
	p.category
)
SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	TO_CHAR(ROUND((total_sales / SUM(total_sales) OVER() ) * 100, 2),'FM999990.00') || '%'  AS prcnt_per_category_sales
FROM category_sales

