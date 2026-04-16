DROP VIEW IF EXISTS v_order_details;
DROP MATERIALIZED VIEW IF EXISTS mv_order_details;
DROP VIEW IF EXISTS v_product_sales;
DROP MATERIALIZED VIEW IF EXISTS mv_product_sales;

CREATE VIEW v_order_details AS
SELECT
    o.id AS order_id,
    o.created_at,
    o.status AS order_status,
    o.total,
    u.id AS user_id,
    u.full_name AS user_name,
    f.name AS pickup_point_name
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN pickup_points pp ON pp.id = o.pickup_point_id
JOIN facilities f ON f.id = pp.id;

CREATE MATERIALIZED VIEW mv_order_details AS
SELECT
    o.id AS order_id,
    o.created_at,
    o.status AS order_status,
    o.total,
    u.id AS user_id,
    u.full_name AS user_name,
    f.name AS pickup_point_name
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN pickup_points pp ON pp.id = o.pickup_point_id
JOIN facilities f ON f.id = pp.id;

CREATE VIEW v_product_sales AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    c.name AS category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.price_at_order) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS orders_count
FROM order_items oi
JOIN products p ON p.id = oi.product_id
JOIN categories c ON c.id = p.category_id
GROUP BY p.id, p.name, c.name;

CREATE MATERIALIZED VIEW mv_product_sales AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    c.name AS category_name,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.price_at_order) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS orders_count
FROM order_items oi
JOIN products p ON p.id = oi.product_id
JOIN categories c ON c.id = p.category_id
GROUP BY p.id, p.name, c.name;
