CREATE VIEW vw_powerbi_master AS
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.order_status,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    c.customer_state,
    c.customer_city,
    oi.product_id,
    t.product_category_name_english AS category,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS item_total,
    s.seller_state,
    r.review_score
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
JOIN sellers s ON oi.seller_id = s.seller_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';