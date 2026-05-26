CREATE TABLE IF NOT EXISTS pending_settlements (
    id UUID PRIMARY KEY,
    transaction_id UUID NOT NULL,
    sender_wallet UUID NOT NULL,
    receiver_wallet UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS authorization_holds (
    id UUID PRIMARY KEY,
    wallet_id UUID NOT NULL,
    transaction_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
