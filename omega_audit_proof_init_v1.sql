CREATE TABLE IF NOT EXISTS audit_log (
    id TEXT PRIMARY KEY,
    event_id TEXT NOT NULL,
    event_hash TEXT NOT NULL,
    prev_hash TEXT,
    chain_hash TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_audit_event_id ON audit_log(event_id);
CREATE INDEX IF NOT EXISTS idx_audit_chain_hash ON audit_log(chain_hash);
