CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    created_at TIMESTAMPTZ
);

CREATE TABLE facilities (
    id BIGINT PRIMARY KEY,
    type VARCHAR(20),
    name VARCHAR(255),
    address TEXT
);

CREATE TABLE categories (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE employee_positions (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    salary NUMERIC(9,2)
);

CREATE TABLE pickup_points (
    id BIGINT PRIMARY KEY REFERENCES facilities(id),
    opening_hours VARCHAR(255)
);

CREATE TABLE warehouses (
    id BIGINT PRIMARY KEY REFERENCES facilities(id),
    capacity INT
);

CREATE TABLE products (
    id BIGINT PRIMARY KEY,
    category_id BIGINT REFERENCES categories(id),
    name VARCHAR(255),
    description TEXT,
    price NUMERIC(9,2)
);

CREATE TABLE employees (
    id BIGINT PRIMARY KEY,
    position_id BIGINT REFERENCES employee_positions(id),
    full_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    hired_at TIMESTAMPTZ,
    status VARCHAR(20)
);

CREATE TABLE orders (
    id BIGINT PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    pickup_point_id BIGINT REFERENCES pickup_points(id),
    created_at TIMESTAMPTZ,
    status VARCHAR(20),
    total NUMERIC(9,2)
);

CREATE TABLE employee_assignments (
    id BIGINT PRIMARY KEY,
    employee_id BIGINT REFERENCES employees(id),
    facility_id BIGINT REFERENCES facilities(id),
    start_date DATE,
    end_date DATE
);

CREATE TABLE order_items (
    order_id BIGINT REFERENCES orders(id),
    product_id BIGINT REFERENCES products(id),
    quantity INT,
    price_at_order NUMERIC(9,2),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE inventory (
    product_id BIGINT REFERENCES products(id),
    warehouse_id BIGINT REFERENCES warehouses(id),
    quantity INT,
    PRIMARY KEY (product_id, warehouse_id)
);
