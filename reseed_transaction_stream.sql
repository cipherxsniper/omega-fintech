TRUNCATE transaction_stream;

INSERT INTO transaction_stream (
    wallet_id,
    amount,
    merchant_risk,
    velocity_1m
)
SELECT
    wallet_id,

    CASE
        WHEN direction = 'CREDIT'
        THEN amount
        ELSE -amount
    END,

    15,
    1

FROM ledger_entries;
