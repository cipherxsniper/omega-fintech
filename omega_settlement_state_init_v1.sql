BEGIN;

CREATE TABLE IF NOT EXISTS omega_settlement_state (
    id UUID PRIMARY KEY,
    settlement_id UUID NOT NULL,
    state TEXT NOT NULL,
    payload JSONB NOT NULL,
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_settlement_state_id
ON omega_settlement_state(settlement_id);

CREATE INDEX IF NOT EXISTS idx_settlement_state_time
ON omega_settlement_state(updated_at);

COMMIT;
