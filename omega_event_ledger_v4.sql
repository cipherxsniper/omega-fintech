CREATE TABLE IF NOT EXISTS ledger_events (
    id UUID PRIMARY KEY,
    event_type TEXT NOT NULL,
    aggregate_id UUID NOT NULL,
    aggregate_type TEXT NOT NULL,
    payload JSONB NOT NULL,
    idempotency_key TEXT UNIQUE,
    sequence_number BIGSERIAL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ledger_events_aggregate
ON ledger_events(aggregate_id);

CREATE INDEX IF NOT EXISTS idx_ledger_events_seq
ON ledger_events(sequence_number);
