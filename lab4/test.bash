  #!/usr/bin/env bash

  env PGPASSWORD=password psql -h localhost -p 5433 -U user -d db -c \
  "SELECT id, full_name, email, phone FROM users ORDER BY
  id LIMIT 3;"

  env PGPASSWORD=secret psql -h localhost -p 5433 -U analyst_masked -d db -c \
  "SELECT id, full_name, email, phone FROM users ORDER BY
  id LIMIT 3;"

  env PGPASSWORD=password psql -h localhost -p 5433 -U user -d db -c \
  "SELECT order_id, created_at, total, user_name,
  pickup_point_name FROM v_order_details ORDER BY order_id
  LIMIT 3;"

  env PGPASSWORD=password psql -h localhost -p 5433 -U user -d db -c \
  "SELECT * FROM mv_order_details ORDER BY order_ref LIMIT
  3;"

  env PGPASSWORD=password psql -h localhost -p 5433 -U user -d db -c \
  "SELECT * FROM v_product_sales ORDER BY product_id LIMIT
  3;"

  env PGPASSWORD=password psql -h localhost -p 5433 -U user -d db -c \
  "SELECT * FROM mv_product_sales ORDER BY product_ref
  LIMIT 3;"