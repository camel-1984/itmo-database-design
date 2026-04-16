x-- 1. JOIN: список заказов с именем клиента и пунктом выдачи.
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

-- 2. GROUP BY + агрегат: самые популярные товары по количеству продаж.
SELECT
    p.id AS product_id,
    p.name AS product_name,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_units_sold DESC, p.id;

-- 3. Оконная функция OVER: ранжирование заказов по сумме.
SELECT
    o.id AS order_id,
    o.total,
    RANK() OVER (ORDER BY o.total DESC) AS order_rank
FROM orders o
ORDER BY order_rank, o.id;

-- 4. Подзапрос в FROM: количество заказов по каждому пользователю.
SELECT
    u.full_name,
    stats.orders_count
FROM users u
JOIN (
    SELECT
        user_id,
        COUNT(*) AS orders_count
    FROM orders
    GROUP BY user_id
) stats ON stats.user_id = u.id
ORDER BY stats.orders_count DESC, u.full_name;

-- 5. CASE: деление заказов на дешевые, средние и дорогие.
SELECT
    id AS order_id,
    total,
    CASE
        WHEN total < 10000 THEN 'cheap'
        WHEN total <= 30000 THEN 'medium'
        ELSE 'expensive'
    END AS price_category
FROM orders
ORDER BY total DESC;
