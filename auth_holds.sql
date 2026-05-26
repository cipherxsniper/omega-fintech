
CREATE TABLE IF NOT EXISTS auth_holds (
    id UUID PRIMARY KEY,
    card_token TEXT NOT NULL,
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    status TEXT NOT NULL, -- HELD | RELEASED | EXPIRED | CAPTURED
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    idempotency_key TEXT UNIQUE
);

CREATE INDEX IF NOT EXISTS idx_auth_wallet ON auth_holds(wallet_id);
CREATE INDEX IF NOT EXISTS idx_auth_status ON auth_holds(status);

