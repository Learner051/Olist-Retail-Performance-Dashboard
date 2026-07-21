WITH category_sales AS (
    SELECT
        t.product_category_name_english AS category,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS sales_month,
        COUNT(oi.order_item_id) AS units_sold,
        SUM(oi.price) AS revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN category_translation t ON p.product_category_name = t.product_category_name
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY t.product_category_name_english, DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT
    category,
    sales_month,
    units_sold,
    revenue,
    SUM(units_sold) OVER (
        PARTITION BY category ORDER BY sales_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3mo_units,
    NTILE(4) OVER (PARTITION BY sales_month ORDER BY units_sold DESC) AS demand_quartile
FROM category_sales
ORDER BY sales_month, units_sold DESC;