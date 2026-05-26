
CREATE TABLE IF NOT EXISTS risk_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id UUID NOT NULL,
    event_type TEXT NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);


CREATE TABLE IF NOT EXISTS velocity_tracking (
    wallet_id UUID PRIMARY KEY,
    window_start TIMESTAMP NOT NULL,
    total_amount NUMERIC(20,2) NOT NULL DEFAULT 0,
    transaction_count INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMP DEFAULT now()
);

