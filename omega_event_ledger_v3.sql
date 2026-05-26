CREATE TABLE IF NOT EXISTS omega_events (
    event_id UUID PRIMARY KEY,
    event_type TEXT NOT NULL,
    aggregate_id UUID NOT NULL,
    aggregate_type TEXT NOT NULL,
    payload JSONB NOT NULL,
    idempotency_key TEXT UNIQUE,
    sequence_number BIGSERIAL,
    created_at TIMESTAMP DEFAULT NOW()
);
