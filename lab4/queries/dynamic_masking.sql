CREATE EXTENSION IF NOT EXISTS anon CASCADE;
SELECT anon.init();

SECURITY LABEL FOR anon ON COLUMN users.full_name
IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';

SECURITY LABEL FOR anon ON COLUMN users.email
IS 'MASKED WITH FUNCTION anon.partial_email(email)';

SECURITY LABEL FOR anon ON COLUMN users.phone
IS 'MASKED WITH FUNCTION anon.partial(phone,2,$$******$$,2)';

SECURITY LABEL FOR anon ON COLUMN employees.full_name
IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';

SECURITY LABEL FOR anon ON COLUMN employees.email
IS 'MASKED WITH FUNCTION anon.partial_email(email)';

SECURITY LABEL FOR anon ON COLUMN employees.phone
IS 'MASKED WITH FUNCTION anon.partial(phone,2,$$******$$,2)';

-- Masking rules on base tables do not propagate to views automatically.
SECURITY LABEL FOR anon ON COLUMN v_order_details.user_name
IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';

SECURITY LABEL FOR anon ON COLUMN mv_order_details.user_name
IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'analyst_masked') THEN
        CREATE ROLE analyst_masked LOGIN PASSWORD 'secret';
    ELSE
        ALTER ROLE analyst_masked WITH LOGIN PASSWORD 'secret';
    END IF;
END $$;

ALTER ROLE analyst_masked SET anon.transparent_dynamic_masking = true;
SECURITY LABEL FOR anon ON ROLE analyst_masked IS 'MASKED';

GRANT CONNECT ON DATABASE db TO analyst_masked;
GRANT USAGE ON SCHEMA public TO analyst_masked;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst_masked;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO analyst_masked;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO analyst_masked;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON SEQUENCES TO analyst_masked;
