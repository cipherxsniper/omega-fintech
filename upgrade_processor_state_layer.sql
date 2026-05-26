
-- =========================================================
-- OMEGA PROCESSOR STATE LAYER
-- Stripe/Visa-style async settlement architecture
-- =========================================================

-- =========================================================
-- WALLET STATE EXPANSION
-- =========================================================

ALTER TABLE wallets
ADD COLUMN IF NOT EXISTS locked_balance NUMERIC(20,2) NOT NULL DEFAULT 0;

ALTER TABLE wallets
ADD COLUMN IF NOT EXISTS settled_balance NUMERIC(20,2) NOT NULL DEFAULT 0;

-- =========================================================
-- AUTHORIZATION HOLDS
-- =========================================================

CREATE TABLE IF NOT EXISTS authorization_holds (

    id UUID PRIMARY KEY,

    wallet_id UUID NOT NULL,

    card_id UUID,

    merchant_name TEXT,

    amount NUMERIC(20,2) NOT NULL CHECK (amount > 0),

    currency TEXT NOT NULL DEFAULT 'USD',

    status TEXT NOT NULL CHECK (
        status IN (
            'AUTHORIZED',
            'CAPTURED',
            'REVERSED',
            'EXPIRED',
            'FAILED'
        )
    ),

    idempotency_key TEXT UNIQUE NOT NULL,

    external_reference TEXT,

    expires_at TIMESTAMP NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT now(),

    updated_at TIMESTAMP NOT NULL DEFAULT now()

);

-- =========================================================
-- SETTLEMENT EVENTS
-- =========================================================

CREATE TABLE IF NOT EXISTS settlement_events (

    id UUID PRIMARY KEY,

    hold_id UUID,

    event_type TEXT NOT NULL CHECK (
        event_type IN (
            'AUTH',
            'CAPTURE',
            'REVERSAL',
            'CLEARING',
            'RECONCILIATION'
        )
    ),

    payload JSONB NOT NULL,

    status TEXT NOT NULL CHECK (
        status IN (
            'PENDING',
            'PROCESSING',
            'SETTLED',
            'FAILED'
        )
    ),

    retry_count INTEGER NOT NULL DEFAULT 0,

    idempotency_key TEXT UNIQUE NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT now(),

    updated_at TIMESTAMP NOT NULL DEFAULT now()

);

-- =========================================================
-- TREASURY LOCKS
-- =========================================================

CREATE TABLE IF NOT EXISTS treasury_locks (

    id UUID PRIMARY KEY,

    wallet_id UUID NOT NULL,

    hold_id UUID NOT NULL,

    amount NUMERIC(20,2) NOT NULL CHECK (amount > 0),

    status TEXT NOT NULL CHECK (
        status IN (
            'LOCKED',
            'RELEASED',
            'SETTLED'
        )
    ),

    created_at TIMESTAMP NOT NULL DEFAULT now(),

    updated_at TIMESTAMP NOT NULL DEFAULT now()

);

-- =========================================================
-- RECONCILIATION SNAPSHOTS
-- =========================================================

CREATE TABLE IF NOT EXISTS reconciliation_snapshots (

    id UUID PRIMARY KEY,

    ledger_total NUMERIC(20,2) NOT NULL,

    wallet_total NUMERIC(20,2) NOT NULL,

    treasury_total NUMERIC(20,2) NOT NULL,

    external_total NUMERIC(20,2) NOT NULL,

    drift NUMERIC(20,2) NOT NULL,

    status TEXT NOT NULL CHECK (
        status IN (
            'MATCHED',
            'DRIFT',
            'CRITICAL'
        )
    ),

    created_at TIMESTAMP NOT NULL DEFAULT now()

);

-- =========================================================
-- INDEXES
-- =========================================================

CREATE INDEX IF NOT EXISTS idx_auth_wallet
ON authorization_holds(wallet_id);

CREATE INDEX IF NOT EXISTS idx_auth_status
ON authorization_holds(status);

CREATE INDEX IF NOT EXISTS idx_settlement_status
ON settlement_events(status);

CREATE INDEX IF NOT EXISTS idx_settlement_hold
ON settlement_events(hold_id);

CREATE INDEX IF NOT EXISTS idx_treasury_lock_wallet
ON treasury_locks(wallet_id);

-- =========================================================
-- WALLET PROJECTION VIEW
-- =========================================================

CREATE OR REPLACE VIEW wallet_state AS

SELECT

    w.id AS wallet_id,

    w.settled_balance,

    w.locked_balance,

    (w.settled_balance - w.locked_balance)
    AS available_balance

FROM wallets w;

