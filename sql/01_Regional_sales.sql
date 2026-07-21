WITH order_revenue AS (
    SELECT order_id, SUM(price + freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
)
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(r.order_total)::numeric, 2) AS total_revenue,
    ROUND(AVG(r.order_total)::numeric, 2) AS avg_order_value,
    RANK() OVER (ORDER BY SUM(r.order_total) DESC) AS revenue_rank
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_revenue r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;