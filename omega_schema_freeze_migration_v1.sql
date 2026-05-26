BEGIN;

-- =====================================================
-- OMEGA EVENT SCHEMA FREEZE v1
-- =====================================================

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS aggregate_id UUID;

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS aggregate_type TEXT;

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS timestamp TIMESTAMP;

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS merchant_id TEXT;

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS wallet_id UUID;

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS amount NUMERIC(18,2);

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS currency TEXT;

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS payload JSONB;

ALTER TABLE omega_events
ADD COLUMN IF NOT EXISTS version INTEGER DEFAULT 1;

COMMIT;
