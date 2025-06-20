-- Analyze how a measure evolves over time
-- Helps track trends and identify seasonality in your data    

--Analyze sales performance over time
-- changes over years gives a high level overview insights that help with strategic decision making
-- date_trunc()

SELECT 
    date_trunc('month', order_date)::date AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales 
WHERE order_date IS NOT NULL
GROUP BY date_trunc('month', order_date)::date
ORDER BY date_trunc('month', order_date)::date;

