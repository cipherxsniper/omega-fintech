
CREATE TABLE IF NOT EXISTS authorization_expirations (
    id UUID PRIMARY KEY,
    auth_id UUID,
    wallet_id UUID,
    expired_amount NUMERIC(20,2),
    expired_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS async_settlement_jobs (
    id UUID PRIMARY KEY,
    auth_id UUID,
    wallet_id UUID,
    merchant TEXT,
    amount NUMERIC(20,2),
    network TEXT,
    priority INTEGER DEFAULT 1,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    processed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS chargeback_cases (
    id UUID PRIMARY KEY,
    auth_id UUID,
    wallet_id UUID,
    merchant TEXT,
    amount NUMERIC(20,2),
    network TEXT,
    reason_code TEXT,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    resolved_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS merchant_batches (
    id UUID PRIMARY KEY,
    merchant TEXT,
    network TEXT,
    batch_total NUMERIC(20,2),
    tx_count INTEGER,
    batch_status TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_async_jobs_status
ON async_settlement_jobs(status);

CREATE INDEX IF NOT EXISTS idx_chargeback_status
ON chargeback_cases(status);

CREATE INDEX IF NOT EXISTS idx_pending_holds_status
ON pending_holds(status);

