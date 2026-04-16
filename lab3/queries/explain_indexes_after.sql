ANALYZE users;
ANALYZE employees;
ANALYZE orders;
ANALYZE order_items;
ANALYZE products;
ANALYZE categories;

\echo ''
\echo '=== AFTER INDEXES: exact match by email ==='
EXPLAIN (ANALYZE)
SELECT *
FROM users
WHERE email = 'user25000@example.com';

EXPLAIN (ANALYZE)
SELECT *
FROM employees
WHERE email = 'employee25000@example.com';

\echo ''
\echo '=== AFTER INDEXES: equality + range ==='
EXPLAIN (ANALYZE)
SELECT *
FROM orders
WHERE status = 'cancelled'
  AND created_at >= TIMESTAMPTZ '2025-10-01';

EXPLAIN (ANALYZE)
SELECT *
FROM employees
WHERE status = 'inactive'
  AND hired_at >= TIMESTAMPTZ '2025-12-01';

\echo ''
\echo '=== INDEX EXISTS BUT IS NOT USED: low selectivity ==='
EXPLAIN (ANALYZE)
SELECT *
FROM orders
  WHERE status IN ('paid', 'created', 'ready', 'completed', 'cancelled', 'shipped');

\echo ''
\echo '=== INDEX EXISTS BUT IS NOT USED: function on indexed column ==='
EXPLAIN (ANALYZE)
SELECT *
FROM users
WHERE lower(email) = lower('user25000@example.com');

