CREATE TABLE IF NOT EXISTS ledger_events (
    id TEXT PRIMARY KEY,
    type TEXT,
    payload TEXT,
    timestamp TEXT
);

CREATE INDEX IF NOT EXISTS idx_ledger_events_id ON ledger_events(id);
