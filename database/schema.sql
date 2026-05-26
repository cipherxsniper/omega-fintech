CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE wallets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID REFERENCES accounts(id),
    currency TEXT NOT NULL,
    available_balance NUMERIC(20,2) DEFAULT 0,
    pending_balance NUMERIC(20,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE ledger_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL,
    debit_account TEXT NOT NULL,
    credit_account TEXT NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    currency TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_id UUID REFERENCES wallets(id),
    amount NUMERIC(20,2),
    status TEXT,
    merchant TEXT,
    risk_score INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE treasury_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reserve_name TEXT,
    reserve_balance NUMERIC(20,2),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    action TEXT,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);
