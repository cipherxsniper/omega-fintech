CREATE TABLE IF NOT EXISTS authorization_holds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL,
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS settlement_queue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL,
    sender_wallet UUID NOT NULL,
    receiver_wallet UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS idempotency_keys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    idempotency_key TEXT UNIQUE NOT NULL,
    transaction_id UUID,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS velocity_tracking (
    wallet_id UUID PRIMARY KEY,
    transaction_count INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT NOW()
);
