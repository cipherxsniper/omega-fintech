
-- =====================================================
-- HOTFIX 1
-- AUTHORIZATION TIMESTAMP DEFAULT
-- =====================================================

ALTER TABLE payment_authorizations
ALTER COLUMN created_at
SET DEFAULT NOW();

UPDATE payment_authorizations
SET created_at = NOW()
WHERE created_at IS NULL;

-- =====================================================
-- HOTFIX 2
-- SETTLEMENT QUEUE AMOUNT COLUMN
-- =====================================================

ALTER TABLE settlement_queue
ADD COLUMN IF NOT EXISTS amount NUMERIC(20,2) DEFAULT 0.00;

-- =====================================================
-- HOTFIX 3
-- REBUILD NETWORK STATE VIEW
-- =====================================================

DROP VIEW IF EXISTS omega_network_state_view;

CREATE VIEW omega_network_state_view AS

WITH replay AS (

    SELECT
        wallet_id,

        COALESCE(
            SUM(
                CASE
                    WHEN direction = 'CREDIT'
                    THEN amount
                    ELSE -amount
                END
            ),
            0
        ) AS replay_balance

    FROM ledger_entries
    GROUP BY wallet_id
)

SELECT
    w.id,
    w.settled_balance,
    r.replay_balance,

    (
        w.settled_balance - r.replay_balance
    ) AS drift

FROM wallets w
LEFT JOIN replay r
ON w.id = r.wallet_id;

