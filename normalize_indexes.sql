
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_indexes WHERE indexname = 'ledger_idempotency_unique'
    ) THEN
        DROP INDEX ledger_idempotency_unique;
    END IF;
END $$;

DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_indexes WHERE indexname = 'idempotency_unique'
    ) THEN
        DROP INDEX idempotency_unique;
    END IF;
END $$;

