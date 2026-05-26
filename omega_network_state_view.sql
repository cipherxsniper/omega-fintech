
CREATE OR REPLACE VIEW omega_network_state_view AS

WITH replay AS (

    SELECT
        wallet_id,

        SUM(
            CASE
                WHEN direction = 'CREDIT'
                THEN amount

                WHEN direction = 'DEBIT'
                THEN -amount

                ELSE 0
            END
        ) AS replay_balance

    FROM ledger_entries

    GROUP BY wallet_id
)

SELECT
    w.id,

    w.settled_balance,

    COALESCE(r.replay_balance, 0) AS replay_balance,

    (
        w.settled_balance
        -
        COALESCE(r.replay_balance, 0)
    ) AS drift

FROM wallets w

LEFT JOIN replay r
ON w.id = r.wallet_id;

