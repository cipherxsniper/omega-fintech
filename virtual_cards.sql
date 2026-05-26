
CREATE TABLE IF NOT EXISTS virtual_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id UUID NOT NULL,

    card_token TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL,

    spend_limit NUMERIC(20,2) DEFAULT 0,
    daily_limit NUMERIC(20,2) DEFAULT 0,

    created_at TIMESTAMP DEFAULT now()
);

