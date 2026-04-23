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
    left(anon.hash(o.id::text), 16) AS order_id,
    anon.generalize_tsrange(
        o.created_at AT TIME ZONE 'Europe/Moscow',
        'month'
    ) AS created_at,
    o.status AS order_status,
    anon.generalize_numrange(o.total, 500) AS total,
    left(anon.hash(u.id::text), 16) AS user_id,
    concat(
        anon.pseudo_first_name(u.id, 'lab4-order-details'),
        ' ',
        anon.pseudo_last_name(u.id, 'lab4-order-details')
    ) AS user_name,
    left(anon.hash(pp.id::text), 16) AS pickup_point_name
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN pickup_points pp ON pp.id = o.pickup_point_id;

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
    left(anon.hash(p.id::text), 16) AS product_id,
    left(anon.hash(p.id::text), 16) AS product_name,
    c.name AS category_name,
    anon.generalize_int8range(SUM(oi.quantity)::bigint, 25) AS total_units_sold,
    ROUND(anon.noise(SUM((oi.quantity * oi.price_at_order)::numeric), 0.05), 2) AS total_revenue,
    anon.generalize_int8range(COUNT(DISTINCT oi.order_id)::bigint, 10) AS orders_count
FROM order_items oi
JOIN orders o ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
JOIN categories c ON c.id = p.category_id
GROUP BY p.id, c.name;
