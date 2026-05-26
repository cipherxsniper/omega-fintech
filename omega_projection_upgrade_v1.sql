DROP TABLE IF EXISTS wallet_state_projection CASCADE;

CREATE TABLE wallet_state_projection (
    wallet_id UUID PRIMARY KEY,

    available_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    pending_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    reserved_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    settled_balance NUMERIC(20,2) NOT NULL DEFAULT 0,

    credit_limit NUMERIC(20,2) NOT NULL DEFAULT 0,
    used_credit NUMERIC(20,2) NOT NULL DEFAULT 0,

    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS treasury_state_projection CASCADE;

CREATE TABLE treasury_state_projection (
    treasury_id UUID PRIMARY KEY,

    reserve_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    outstanding_liabilities NUMERIC(20,2) NOT NULL DEFAULT 0,

    updated_at TIMESTAMP DEFAULT NOW()
);
