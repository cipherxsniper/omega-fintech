CREATE TABLE IF NOT EXISTS wallet_state_projection (
    wallet_id UUID PRIMARY KEY,
    settled_balance NUMERIC(20,2) DEFAULT 0,
    reserved_balance NUMERIC(20,2) DEFAULT 0,
    pending_balance NUMERIC(20,2) DEFAULT 0,
    updated_at TIMESTAMP DEFAULT NOW()
);
