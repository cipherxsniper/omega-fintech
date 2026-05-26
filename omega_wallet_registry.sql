CREATE TABLE IF NOT EXISTS wallet_registry (
    alias TEXT PRIMARY KEY,
    wallet_id UUID UNIQUE NOT NULL
);
