-- REAL-TIME CONSENSUS MONITORING

CREATE OR REPLACE VIEW v_consensus_health AS
SELECT
    w.id AS wallet_id,
    w.settled_balance AS live_balance,

    COALESCE((
        SELECT SUM(
            CASE
                WHEN direction = 'CREDIT' THEN amount
                ELSE -amount
            END
        )
        FROM ledger_entries le
        WHERE le.wallet_id = w.id
    ), 0) AS replay_balance,

    (w.settled_balance -
        COALESCE((
            SELECT SUM(
                CASE
                    WHEN direction = 'CREDIT' THEN amount
                    ELSE -amount
                END
            )
            FROM ledger_entries le
            WHERE le.wallet_id = w.id
        ), 0)
    ) AS drift

FROM wallets w;
