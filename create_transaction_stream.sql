CREATE TABLE IF NOT EXISTS transaction_stream (
    id BIGSERIAL PRIMARY KEY,
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    merchant_risk NUMERIC(10,2) DEFAULT 0,
    velocity_1m NUMERIC(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);
