ANALYZE users;
ANALYZE orders;
ANALYZE order_items;
ANALYZE products;
ANALYZE categories;

\echo ''
\echo '=== VIEW vs MATERIALIZED VIEW: order details ==='
EXPLAIN (ANALYZE)
SELECT *
FROM v_order_details
WHERE order_status = 'cancelled';   

EXPLAIN (ANALYZE)
SELECT *
FROM mv_order_details
WHERE order_status = 'cancelled';

\echo ''
\echo '=== VIEW vs MATERIALIZED VIEW: product sales ==='
EXPLAIN (ANALYZE)
SELECT *
FROM v_product_sales
WHERE total_units_sold >= 120;

EXPLAIN (ANALYZE)
SELECT *
FROM mv_product_sales
WHERE total_units_sold >= 120;
