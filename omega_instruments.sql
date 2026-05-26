CREATE TABLE omega_instruments (
    instrument_id UUID PRIMARY KEY,
    wallet_id UUID NOT NULL,
    instrument_token TEXT UNIQUE NOT NULL,
    instrument_type TEXT NOT NULL,
    status TEXT NOT NULL,
    spend_limit NUMERIC(20,2) DEFAULT 0,
    currency TEXT DEFAULT 'OMEGA_USD',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_instrument_token ON omega_instruments(instrument_token);
