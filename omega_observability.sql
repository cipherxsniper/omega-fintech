-- =========================================
-- OMEGA FINANCIAL OBSERVABILITY LAYER
-- READ-ONLY SYSTEM INTELLIGENCE VIEWS
-- =========================================

-- 1. WALLET HEALTH SNAPSHOT
CREATE OR REPLACE VIEW obs_wallet_health AS
SELECT
    w.wallet_id,
    w.settled_balance,
    w.locked_balance,
    (w.settled_balance - w.locked_balance) AS available_balance,
    COALESCE(SUM(
        CASE
            WHEN le.direction = 'CREDIT' THEN le.amount
            ELSE -le.amount
        END
    ), 0) AS ledger_balance,
    (w.settled_balance - COALESCE(SUM(
        CASE
            WHEN le.direction = 'CREDIT' THEN le.amount
            ELSE -le.amount
        END
    ), 0)) AS drift
FROM wallet_state w
LEFT JOIN ledger_entries le ON w.wallet_id = le.wallet_id
GROUP BY w.wallet_id, w.settled_balance, w.locked_balance;


-- 2. LIVE SETTLEMENT QUEUE STATE
CREATE OR REPLACE VIEW obs_queue_state AS
SELECT
    status,
    COUNT(*) AS count,
    MIN(created_at) AS oldest,
    MAX(updated_at) AS newest
FROM settlement_queue
GROUP BY status;


-- 3. INVARIANT FAILURE STREAM
CREATE OR REPLACE VIEW obs_invariant_stream AS
SELECT
    invariant_name,
    severity,
    detected_at,
    failure_details
FROM invariant_failures
ORDER BY detected_at DESC;


-- 4. HIGH RISK WALLETS (DRIFT DETECTION)
CREATE OR REPLACE VIEW obs_drift_alerts AS
SELECT *
FROM obs_wallet_health
WHERE ABS(drift) > 0.01;


-- 5. LEDGER ACTIVITY STREAM
CREATE OR REPLACE VIEW obs_ledger_activity AS
SELECT
    wallet_id,
    COUNT(*) AS tx_count,
    SUM(CASE WHEN direction='CREDIT' THEN amount ELSE 0 END) AS credits,
    SUM(CASE WHEN direction='DEBIT' THEN amount ELSE 0 END) AS debits
FROM ledger_entries
GROUP BY wallet_id;
