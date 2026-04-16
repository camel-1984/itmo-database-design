ANALYZE users;
ANALYZE employees;
ANALYZE orders;
ANALYZE order_items;
ANALYZE products;
ANALYZE categories;

\echo ''
\echo '=== BEFORE INDEXES: exact match by email ==='
EXPLAIN (ANALYZE)
SELECT *
FROM users
WHERE email = 'user25000@example.com';

EXPLAIN (ANALYZE)
SELECT *
FROM employees
WHERE email = 'employee25000@example.com';

\echo ''
\echo '=== BEFORE INDEXES: equality + range ==='
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
