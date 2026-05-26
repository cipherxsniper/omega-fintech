CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS payment_requests CASCADE;
DROP TABLE IF EXISTS merchants CASCADE;
DROP TABLE IF EXISTS tokens CASCADE;
DROP TABLE IF EXISTS cards CASCADE;

CREATE TABLE cards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id UUID NOT NULL,
    card_number TEXT UNIQUE NOT NULL,
    cvv TEXT NOT NULL,
    expiration_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    card_id UUID NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    token_value TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE merchants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    merchant_id TEXT UNIQUE NOT NULL,
    api_key TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE payment_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id),
    amount NUMERIC(20,2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'USD',
    description TEXT DEFAULT '',
    status TEXT NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_request_id UUID REFERENCES payment_requests(id),
    wallet_id UUID NOT NULL,
    card_id UUID REFERENCES cards(id),
    token_id UUID REFERENCES tokens(id),

    event_id UUID NOT NULL REFERENCES ledger_events(event_id),

    amount NUMERIC(20,2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'USD',

    transaction_type TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'PENDING',

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    idempotency_key UUID UNIQUE NOT NULL
);

CREATE INDEX idx_cards_wallet_id
ON cards(wallet_id);

CREATE INDEX idx_cards_card_number
ON cards(card_number);

CREATE INDEX idx_tokens_card_id
ON tokens(card_id);

CREATE INDEX idx_tokens_token_value
ON tokens(token_value);

CREATE INDEX idx_merchants_merchant_id
ON merchants(merchant_id);

CREATE INDEX idx_payment_requests_merchant_id
ON payment_requests(merchant_id);

CREATE INDEX idx_payment_transactions_wallet_id
ON payment_transactions(wallet_id);

CREATE INDEX idx_payment_transactions_event_id
ON payment_transactions(event_id);

CREATE INDEX idx_payment_transactions_idempotency_key
ON payment_transactions(idempotency_key);

CREATE TRIGGER update_cards_updated_at
BEFORE UPDATE ON cards
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tokens_updated_at
BEFORE UPDATE ON tokens
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_merchants_updated_at
BEFORE UPDATE ON merchants
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_requests_updated_at
BEFORE UPDATE ON payment_requests
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_transactions_updated_at
BEFORE UPDATE ON payment_transactions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
