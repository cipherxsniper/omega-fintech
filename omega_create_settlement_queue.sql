CREATE TABLE IF NOT EXISTS settlement_queue (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    auth_id UUID NOT NULL,

    wallet_id UUID NOT NULL,

    amount NUMERIC(20,2) NOT NULL,

    status TEXT NOT NULL DEFAULT 'PENDING',

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_settlement_queue_status
ON settlement_queue(status);

CREATE INDEX IF NOT EXISTS idx_settlement_queue_created
ON settlement_queue(created_at);
