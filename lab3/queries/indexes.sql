DROP INDEX IF EXISTS idx_users_email;
DROP INDEX IF EXISTS idx_employees_email;
DROP INDEX IF EXISTS idx_orders_status_created_at;
DROP INDEX IF EXISTS idx_employees_status_hired_at;

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_employees_email ON employees(email);

CREATE INDEX idx_orders_status_created_at ON orders(status, created_at);
CREATE INDEX idx_employees_status_hired_at ON employees(status, hired_at);