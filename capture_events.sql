
CREATE TABLE IF NOT EXISTS capture_events (
    id UUID PRIMARY KEY,
    auth_id UUID NOT NULL,
    card_token TEXT NOT NULL,
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    merchant TEXT NOT NULL,
    status TEXT NOT NULL, -- CAPTURED | FAILED
    created_at TIMESTAMP DEFAULT now(),
    idempotency_key TEXT UNIQUE
);

CREATE INDEX IF NOT EXISTS idx_capture_auth ON capture_events(auth_id);

