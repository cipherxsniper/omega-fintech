CREATE TABLE IF NOT EXISTS wallets (
    id UUID PRIMARY KEY,
    settled_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    reserved_balance NUMERIC(20,2) NOT NULL DEFAULT 0,
    available_balance NUMERIC(20,2)
        GENERATED ALWAYS AS (settled_balance - reserved_balance) STORED
);

CREATE INDEX IF NOT EXISTS idx_wallet_balance ON wallets(id);
