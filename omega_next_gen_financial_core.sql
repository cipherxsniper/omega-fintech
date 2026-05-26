
CREATE TABLE IF NOT EXISTS dispute_cases (
    id UUID PRIMARY KEY,
    auth_id UUID,
    wallet_id UUID,
    merchant TEXT,
    amount NUMERIC(20,2),
    reason TEXT,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS interchange_fee_events (
    id UUID PRIMARY KEY,
    auth_id UUID,
    network TEXT,
    fee_amount NUMERIC(20,2),
    fee_percent NUMERIC(10,4),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pending_holds (
    id UUID PRIMARY KEY,
    auth_id UUID,
    wallet_id UUID,
    hold_amount NUMERIC(20,2),
    expires_at TIMESTAMP,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS network_clearance_windows (
    id UUID PRIMARY KEY,
    network TEXT,
    settlement_window TEXT,
    cutoff_time TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fraud_velocity_state (
    wallet_id UUID PRIMARY KEY,
    tx_count_1m INTEGER DEFAULT 0,
    tx_volume_1m NUMERIC(20,2) DEFAULT 0,
    risk_score NUMERIC(10,2) DEFAULT 0,
    blocked BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ach_wire_events (
    id UUID PRIMARY KEY,
    wallet_id UUID,
    rail TEXT,
    direction TEXT,
    amount NUMERIC(20,2),
    external_reference TEXT,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS settlement_batches (
    id UUID PRIMARY KEY,
    network TEXT,
    batch_total NUMERIC(20,2),
    tx_count INTEGER,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS issuer_queue (
    id UUID PRIMARY KEY,
    event_type TEXT,
    payload JSONB,
    status TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reserve_segments (
    id UUID PRIMARY KEY,
    segment_name TEXT,
    reserve_type TEXT,
    balance NUMERIC(20,2),
    locked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS currency_treasury (
    currency_code TEXT PRIMARY KEY,
    treasury_balance NUMERIC(20,2),
    reserved_balance NUMERIC(20,2),
    updated_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO network_clearance_windows (
    id,
    network,
    settlement_window,
    cutoff_time
)
VALUES
(gen_random_uuid(),'VISA','T+1','17:00'),
(gen_random_uuid(),'MASTERCARD','T+1','18:00'),
(gen_random_uuid(),'ACH','T+2','16:00')
ON CONFLICT DO NOTHING;

INSERT INTO reserve_segments (
    id,
    segment_name,
    reserve_type,
    balance,
    locked
)
VALUES
(gen_random_uuid(),'OMEGA_HOT','HOT',250000000.00,FALSE),
(gen_random_uuid(),'OMEGA_COLD','COLD',750000000.00,TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO currency_treasury (
    currency_code,
    treasury_balance,
    reserved_balance
)
VALUES
('USD',1000000000.00,250000000.00),
('EUR',250000000.00,50000000.00),
('GBP',150000000.00,25000000.00)
ON CONFLICT (currency_code)
DO NOTHING;

