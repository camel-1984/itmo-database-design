SELECT
    o.id AS order_id,
    u.full_name AS user_name,
    f.name AS pickup_point_name,
    o.status,
    o.total
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN pickup_points pp ON pp.id = o.pickup_point_id
JOIN facilities f ON f.id = pp.id
ORDER BY o.id;

SELECT
    p.id AS product_id,
    p.name AS product_name,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_units_sold DESC, p.id;
