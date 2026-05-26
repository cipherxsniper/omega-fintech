
-- =========================================================
-- OMEGA DOUBLE ENTRY ENFORCEMENT LAYER
-- =========================================================

-- Each ledger entry is immutable and signed logically by structure

CREATE TABLE IF NOT EXISTS ledger_entries (
    id UUID PRIMARY KEY,
    transaction_id UUID NOT NULL,
    wallet_id UUID NOT NULL,
    direction TEXT NOT NULL CHECK (direction IN ('DEBIT','CREDIT')),
    amount NUMERIC(20,2) NOT NULL CHECK (amount > 0),
    idempotency_key TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ---------------------------------------------------------
-- ENFORCE: NO ORPHAN TRANSACTIONS (must belong to TX)
-- ---------------------------------------------------------

ALTER TABLE ledger_entries
    ADD CONSTRAINT fk_transaction
    FOREIGN KEY (transaction_id)
    REFERENCES ledger_transactions(id)
    ON DELETE RESTRICT;

-- ---------------------------------------------------------
-- ENFORCE: DOUBLE ENTRY BALANCE RULE (via trigger)
-- ---------------------------------------------------------

CREATE OR REPLACE FUNCTION check_double_entry_balance()
RETURNS TRIGGER AS $$
DECLARE
    debit_total NUMERIC;
    credit_total NUMERIC;
BEGIN

    SELECT COALESCE(SUM(amount),0)
    INTO debit_total
    FROM ledger_entries
    WHERE transaction_id = NEW.transaction_id
      AND direction = 'DEBIT';

    SELECT COALESCE(SUM(amount),0)
    INTO credit_total
    FROM ledger_entries
    WHERE transaction_id = NEW.transaction_id
      AND direction = 'CREDIT';

    IF debit_total != credit_total THEN
        RAISE EXCEPTION 'UNBALANCED TRANSACTION: DEBIT=% CREDIT=%',
            debit_total, credit_total;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS enforce_balance ON ledger_entries;

CREATE TRIGGER enforce_balance
AFTER INSERT ON ledger_entries
FOR EACH ROW
EXECUTE FUNCTION check_double_entry_balance();

