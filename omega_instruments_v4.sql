CREATE TABLE IF NOT EXISTS omega_instruments (
    instrument_id UUID PRIMARY KEY,
    wallet_id UUID NOT NULL,
    instrument_token TEXT UNIQUE NOT NULL,
    instrument_type TEXT NOT NULL,
    status TEXT NOT NULL,
    spend_limit NUMERIC(20,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);
