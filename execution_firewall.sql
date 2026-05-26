-- HARD RULE: ledger is immutable

CREATE OR REPLACE FUNCTION block_ledger_mutation()
RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION 'LEDGER IMMUTABLE - WRITE BLOCKED';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS ledger_guard ON ledger_entries;

CREATE TRIGGER ledger_guard
BEFORE UPDATE OR DELETE ON ledger_entries
FOR EACH ROW EXECUTE FUNCTION block_ledger_mutation();
