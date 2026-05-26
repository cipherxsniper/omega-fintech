CREATE TABLE IF NOT EXISTS wallet_state_projection (
    wallet_id UUID PRIMARY KEY,
    available_balance NUMERIC(20,2) DEFAULT 0,
    pending_balance NUMERIC(20,2) DEFAULT 0,
    reserved_balance NUMERIC(20,2) DEFAULT 0,
    credit_limit NUMERIC(20,2) DEFAULT 0,
    used_credit NUMERIC(20,2) DEFAULT 0,
    updated_at TIMESTAMP DEFAULT NOW()
);
