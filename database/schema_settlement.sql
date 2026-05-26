CREATE TABLE IF NOT EXISTS pending_settlements (
    id UUID PRIMARY KEY,
    transaction_id TEXT UNIQUE,
    sender_wallet TEXT,
    receiver_wallet TEXT,
    amount NUMERIC(20,2),
    status TEXT,
    attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
