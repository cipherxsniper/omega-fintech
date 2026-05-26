ALTER TABLE ledger_postings
ADD COLUMN IF NOT EXISTS prev_hash TEXT,
ADD COLUMN IF NOT EXISTS event_hash TEXT,
ADD COLUMN IF NOT EXISTS chain_hash TEXT;

CREATE INDEX IF NOT EXISTS idx_ledger_chain_hash
ON ledger_postings(chain_hash);
