
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ledger_entries_idempotency_key_key'
    ) THEN
        ALTER TABLE ledger_entries
        ADD CONSTRAINT ledger_entries_idempotency_key_key UNIQUE (idempotency_key);
    END IF;
END $$;

