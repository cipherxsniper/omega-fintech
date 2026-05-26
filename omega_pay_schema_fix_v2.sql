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
DROP TABLE IF EXISTS tokens CASCADE;
DROP TABLE IF EXISTS cards CASCADE;
DROP TABLE IF EXISTS merchants CASCADE;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'card_status_type'
    ) THEN
        CREATE TYPE card_status_type AS ENUM (
            'ACTIVE',
            'FROZEN',
            'EXPIRED',
            'REVOKED'
        );
    END IF;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'token_status_type'
    ) THEN
        CREATE TYPE token_status_type AS ENUM (
            'ACTIVE',
            'SUSPENDED',
            'DEACTIVATED'
        );
    END IF;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'merchant_status_type'
    ) THEN
        CREATE TYPE merchant_status_type AS ENUM (
            'ACTIVE',
            'INACTIVE',
            'SUSPENDED'
        );
    END IF;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'payment_request_status_type'
    ) THEN
        CREATE TYPE payment_request_status_type AS ENUM (
            'PENDING',
            'COMPLETED',
            'CANCELLED',
            'EXPIRED'
        );
    END IF;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'payment_transaction_type'
    ) THEN
        CREATE TYPE payment_transaction_type AS ENUM (
            'AUTHORIZATION',
            'RESERVATION',
            'SETTLEMENT',
            'DECLINE'
        );
    END IF;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'payment_transaction_status'
    ) THEN
        CREATE TYPE payment_transaction_status AS ENUM (
            'PENDING',
            'APPROVED',
            'DECLINED',
            'SETTLED',
            'REFUNDED'
        );
    END IF;
END$$;

CREATE TABLE merchants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    merchant_id TEXT UNIQUE NOT NULL,
    api_key TEXT NOT NULL,
    status merchant_status_type NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE cards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id UUID NOT NULL,
    card_number TEXT UNIQUE NOT NULL,
    cvv TEXT NOT NULL,
    expiration_date DATE NOT NULL,
    status card_status_type NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    card_id UUID NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    token_value TEXT UNIQUE NOT NULL,
    status token_status_type NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE payment_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id),
    amount NUMERIC(20,2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'USD',
    description TEXT DEFAULT '',
    status payment_request_status_type NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    payment_request_id UUID REFERENCES payment_requests(id),

    wallet_id UUID NOT NULL,

    card_id UUID REFERENCES cards(id),

    token_id UUID REFERENCES tokens(id),

    ledger_event_id UUID REFERENCES ledger_events(id),

    amount NUMERIC(20,2) NOT NULL,

    currency TEXT NOT NULL DEFAULT 'USD',

    transaction_type payment_transaction_type NOT NULL,

    status payment_transaction_status NOT NULL DEFAULT 'PENDING',

    idempotency_key UUID UNIQUE NOT NULL,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    updated_at TIMESTAMPTZ DEFAULT NOW()
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

CREATE INDEX idx_payment_transactions_ledger_event_id
ON payment_transactions(ledger_event_id);

CREATE INDEX idx_payment_transactions_status
ON payment_transactions(status);

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

