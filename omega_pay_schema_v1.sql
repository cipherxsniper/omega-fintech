-- New SQL Schema for Omega Pay System

-- Extend existing ENUMs or create new ones as needed
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'CARD_ISSUED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'CARD_STATUS_UPDATED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'TOKEN_ISSUED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'TOKEN_STATUS_UPDATED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'MERCHANT_REGISTERED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'PAYMENT_REQUEST_CREATED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'PAYMENT_AUTHORIZED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'PAYMENT_RESERVED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'PAYMENT_SETTLED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'PAYMENT_DECLINED';
ALTER TYPE event_type ADD VALUE IF NOT EXISTS 'PAYMENT_REFUNDED';

CREATE TYPE card_status_type AS ENUM (
    'ACTIVE',
    'FROZEN',
    'EXPIRED',
    'REVOKED'
);

CREATE TYPE token_status_type AS ENUM (
    'ACTIVE',
    'SUSPENDED',
    'DEACTIVATED'
);

CREATE TYPE merchant_status_type AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED'
);

CREATE TYPE payment_request_status_type AS ENUM (
    'PENDING',
    'COMPLETED',
    'CANCELLED',
    'EXPIRED'
);

CREATE TYPE payment_transaction_type AS ENUM (
    'AUTHORIZATION',
    'RESERVATION',
    'SETTLEMENT',
    'DECLINE'
);

CREATE TYPE payment_transaction_status AS ENUM (
    'PENDING',
    'APPROVED',
    'DECLINED',
    'SETTLED',
    'REFUNDED'
);

CREATE TABLE cards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
    card_number TEXT UNIQUE NOT NULL,
    cvv TEXT NOT NULL,
    expiration_date DATE NOT NULL,
    status card_status_type NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_cards_wallet_id ON cards(wallet_id);
CREATE INDEX idx_cards_card_number ON cards(card_number);
CREATE INDEX idx_cards_status ON cards(status);

CREATE TABLE tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    card_id UUID NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    token_value TEXT UNIQUE NOT NULL,
    status token_status_type NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_tokens_card_id ON tokens(card_id);
CREATE INDEX idx_tokens_token_value ON tokens(token_value);
CREATE INDEX idx_tokens_status ON tokens(status);

CREATE TABLE merchants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    merchant_id TEXT UNIQUE NOT NULL,
    api_key TEXT NOT NULL,
    status merchant_status_type NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_merchants_merchant_id ON merchants(merchant_id);
CREATE INDEX idx_merchants_status ON merchants(status);

CREATE TABLE payment_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE RESTRICT,
    amount NUMERIC(20,2) NOT NULL CHECK (amount > 0),
    currency TEXT NOT NULL DEFAULT 'USD',
    description TEXT NOT NULL DEFAULT '',
    status payment_request_status_type NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_payment_requests_merchant_id ON payment_requests(merchant_id);
CREATE INDEX idx_payment_requests_status ON payment_requests(status);

CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_request_id UUID REFERENCES payment_requests(id) ON DELETE RESTRICT,
    wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE RESTRICT,
    card_id UUID REFERENCES cards(id) ON DELETE RESTRICT,
    token_id UUID REFERENCES tokens(id) ON DELETE RESTRICT,
    event_id UUID NOT NULL REFERENCES events(event_id) ON DELETE RESTRICT,
    amount NUMERIC(20,2) NOT NULL CHECK (amount > 0),
    currency TEXT NOT NULL DEFAULT 'USD',
    transaction_type payment_transaction_type NOT NULL,
    status payment_transaction_status NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    idempotency_key UUID UNIQUE NOT NULL
);

CREATE INDEX idx_payment_transactions_payment_request_id ON payment_transactions(payment_request_id);
CREATE INDEX idx_payment_transactions_wallet_id ON payment_transactions(wallet_id);
CREATE INDEX idx_payment_transactions_card_id ON payment_transactions(card_id);
CREATE INDEX idx_payment_transactions_token_id ON payment_transactions(token_id);
CREATE INDEX idx_payment_transactions_event_id ON payment_transactions(event_id);
CREATE INDEX idx_payment_transactions_idempotency_key ON payment_transactions(idempotency_key);
CREATE INDEX idx_payment_transactions_status ON payment_transactions(status);

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
