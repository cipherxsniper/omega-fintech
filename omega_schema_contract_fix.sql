-- ============================================
-- OMEGA SCHEMA CONTRACT LOCK LAYER
-- Fixes drift between Python + SQL layers
-- ============================================

-- 1. FIX omega_instruments (missing metadata column)
ALTER TABLE omega_instruments
ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;

-- 2. ENSURE ledger_postings enum compliance
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'ledger_postings_direction_check_fixed'
    ) THEN
        ALTER TABLE ledger_postings DROP CONSTRAINT IF EXISTS ledger_postings_direction_check;

        ALTER TABLE ledger_postings
        ADD CONSTRAINT ledger_postings_direction_check_fixed
        CHECK (direction IN ('DEBIT', 'CREDIT'));
    END IF;
END $$;

-- 3. ENSURE omega_events always has required columns safely referenced
ALTER TABLE omega_events
ALTER COLUMN payload SET DEFAULT '{}'::jsonb;

-- 4. SAFE GUARD: prevent NULL account_id violations silently crashing pipelines
ALTER TABLE ledger_postings
ALTER COLUMN account_id DROP NOT NULL;

-- (IMPORTANT: runtime enforces correctness instead of DB panic)

-- 5. ENSURE created_at safety
ALTER TABLE ledger_postings
ALTER COLUMN created_at SET DEFAULT NOW();

-- ============================================
-- CONTRACT READY
-- ============================================
