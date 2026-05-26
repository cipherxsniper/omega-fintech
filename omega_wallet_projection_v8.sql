CREATE TABLE IF NOT EXISTS wallet_state_projection (
    wallet_id UUID PRIMARY KEY,
    settled_balance NUMERIC(20,2) DEFAULT 0,
    reserved_balance NUMERIC(20,2) DEFAULT 0,
    pending_balance NUMERIC(20,2) DEFAULT 0,
    available_balance NUMERIC(20,2) GENERATED ALWAYS AS (
        settled_balance - reserved_balance - pending_balance
    ) STORED,
    last_event_sequence BIGINT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT NOW()
);
