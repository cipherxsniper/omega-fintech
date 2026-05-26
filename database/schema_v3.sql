CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    pin_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_wallets (
    user_id UUID REFERENCES users(id),
    wallet_id UUID REFERENCES wallets(id),
    PRIMARY KEY (user_id, wallet_id)
);
