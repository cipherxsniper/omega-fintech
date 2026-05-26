
BEGIN;

DROP VIEW IF EXISTS v_wallet_balances;
DROP VIEW IF EXISTS v_spendable_only;

CREATE VIEW v_wallet_balances AS
SELECT
    w.id AS wallet_id,

    COALESCE(SUM(
        CASE
            WHEN le.direction = 'CREDIT' THEN le.amount
            ELSE -le.amount
        END
    ), 0) AS ledger_balance,

    w.settled_balance,
    w.locked_balance,

    (w.settled_balance - w.locked_balance) AS spendable_balance,

    (w.settled_balance -
     COALESCE(SUM(
        CASE
            WHEN le.direction = 'CREDIT' THEN le.amount
            ELSE -le.amount
        END
    ), 0)) AS drift

FROM wallets w
LEFT JOIN ledger_entries le
    ON le.wallet_id = w.id
GROUP BY w.id, w.settled_balance, w.locked_balance;


CREATE VIEW v_spendable_only AS
SELECT
    id AS wallet_id,
    (settled_balance - locked_balance) AS spendable_balance
FROM wallets;

COMMIT;

