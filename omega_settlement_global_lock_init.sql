CREATE TABLE IF NOT EXISTS omega_settlement_global_lock (
    event_id UUID PRIMARY KEY,
    hash TEXT NOT NULL,
    locked_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_global_lock_hash
ON omega_settlement_global_lock(hash);
