
-- =========================================
-- OMEGA BALANCE VIEW LAYER (FIXED)
-- Schema-aligned, no assumptions
-- =========================================

-- FULL WALLET BALANCE + DRIFT
CREATE OR REPLACE VIEW v_wallet_balances AS
SELECT
    w.wallet_id,

    -- ledger truth
    COALESCE(SUM(
        CASE
            WHEN le.direction = 'CREDIT' THEN le.amount
            ELSE -le.amount
        END
    ), 0) AS ledger_balance,

    -- stored state
    w.settled_balance,
    w.locked_balance,

    -- spendable
    (w.settled_balance - w.locked_balance) AS spendable_balance,

    -- drift detection
    (w.settled_balance -
     COALESCE(SUM(
        CASE
            WHEN le.direction = 'CREDIT' THEN le.amount
            ELSE -le.amount
        END
    ), 0)) AS drift

FROM wallets w
LEFT JOIN ledger_entries le
    ON le.wallet_id = w.wallet_id
GROUP BY
    w.wallet_id,
    w.settled_balance,
    w.locked_balance;


-- SPENDABLE ONLY VIEW
CREATE OR REPLACE VIEW v_spendable_only AS
SELECT
    wallet_id,
    (settled_balance - locked_balance) AS spendable_balance
FROM wallets;


-- SYSTEM HEALTH SNAPSHOT
CREATE OR REPLACE VIEW v_balance_health AS
SELECT
    COUNT(*) AS total_wallets,
    SUM(settled_balance - locked_balance) AS total_spendable,
    COUNT(*) FILTER (
        WHERE wallet_id IN (
            SELECT wallet_id FROM v_wallet_balances WHERE drift <> 0
        )
    ) AS drifted_wallets
FROM wallets;

