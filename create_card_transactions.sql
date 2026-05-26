
CREATE TABLE IF NOT EXISTS card_transactions (
    id UUID PRIMARY KEY,
    card_token TEXT NOT NULL,
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    merchant TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    idempotency_key TEXT UNIQUE
);

CREATE INDEX IF NOT EXISTS idx_card_tx_wallet ON card_transactions(wallet_id);
CREATE INDEX IF NOT EXISTS idx_card_tx_token ON card_transactions(card_token);

