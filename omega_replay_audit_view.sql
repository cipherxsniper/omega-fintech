-- TIME-TRAVEL FINANCIAL RECONSTRUCTION VIEW

CREATE OR REPLACE VIEW v_wallet_replay_audit AS
SELECT
    wallet_id,
    direction,
    amount,
    created_at,

    SUM(
        CASE
            WHEN direction = 'CREDIT' THEN amount
            ELSE -amount
        END
    ) OVER (
        PARTITION BY wallet_id
        ORDER BY created_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_balance

FROM ledger_entries;
