INSERT INTO transaction_stream (
    wallet_id,
    amount,
    merchant_risk,
    velocity_1m
)
SELECT
    wallet_id,
    ABS(amount),
    15,
    1
FROM ledger_entries
LIMIT 1000;
