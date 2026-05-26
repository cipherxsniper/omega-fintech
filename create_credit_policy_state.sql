CREATE TABLE IF NOT EXISTS credit_policy_state (
    wallet_id UUID PRIMARY KEY,
    current_limit NUMERIC(20,2) NOT NULL DEFAULT 0,
    state TEXT NOT NULL DEFAULT 'ACTIVE',
    last_updated TIMESTAMP DEFAULT NOW()
);
