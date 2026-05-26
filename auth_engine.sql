
CREATE TABLE IF NOT EXISTS authorization_holds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    status TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    idempotency_key TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT now()
);


CREATE TABLE IF NOT EXISTS capture_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id UUID NOT NULL,
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    status TEXT NOT NULL,
    idempotency_key TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT now()
);

