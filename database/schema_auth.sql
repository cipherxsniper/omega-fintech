CREATE TABLE IF NOT EXISTS api_keys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    api_key TEXT UNIQUE NOT NULL,
    owner_name TEXT NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS jwt_blacklist (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    token TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transaction_replay_protection (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_hash TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
