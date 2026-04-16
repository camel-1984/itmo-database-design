DO $$
BEGIN
    EXECUTE format(
        'ALTER DATABASE %I SET session_preload_libraries = %L',
        current_database(),
        'anon'
    );
    EXECUTE format(
        'ALTER DATABASE %I SET anon.transparent_dynamic_masking = %L',
        current_database(),
        'true'
    );
END $$;

CREATE EXTENSION IF NOT EXISTS anon CASCADE;
SELECT anon.init();
