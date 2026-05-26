BEGIN;

CREATE TABLE IF NOT EXISTS omega_idempotency_log (
    id UUID PRIMARY KEY,
    event_id UUID NOT NULL,
    idempotency_key TEXT,
    event_type TEXT NOT NULL,
    payload JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_omega_idempotency_event_id
ON omega_idempotency_log(event_id);

CREATE INDEX IF NOT EXISTS idx_omega_idempotency_key
ON omega_idempotency_log(idempotency_key);

COMMIT;
