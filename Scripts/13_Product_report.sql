/* 
   Product report
   Purpose:
   	- This report consolidates key product metrices and behaviours.
   	
   	
   	Highlights :
   	 1.Gathers essential fields such as product name, category, subcategory, and cost. 
   	 2.Segments products by revenue to identify High_Performance, Mid_Range, or Low-Performance.
   	 3.Aggregates product-level metrices:
   	  	 - total orders
     	 - total sales
     	 - total quantity sold
     	 - total customers (unique)
     	 - lifespan (in months)
     4.Calculate valuable KPIs:
     	 - recency (month since last sales)
     	 - average order value (AOR)
     	 - average monthly revenue
 */



CREATE VIEW report_products AS
WITH base_query AS (
    SELECT 
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM fact_sales f
    LEFT JOIN dim_products p ON p.product_key = f.product_key
    WHERE f.order_date IS NOT NULL
), product_aggregation AS (
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customers,
        ROUND(
            CAST(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)) AS numeric),
            1
        ) AS avg_selling_price
    FROM base_query
    GROUP BY 
        product_key,
        product_name,
        category,
        subcategory,
        cost
)
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_order_date,
    EXTRACT(YEAR FROM AGE(current_date, last_order_date)) * 12 +
    EXTRACT(MONTH FROM AGE(current_date, last_order_date)) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Ranger'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    CASE
        WHEN total_orders = 0 THEN total_sales
        ELSE total_sales / total_orders
    END AS avg_order_revenue,
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue
FROM product_aggregation;