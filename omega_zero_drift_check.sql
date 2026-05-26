SELECT
    (SELECT COALESCE(SUM(amount),0) FROM settlement_queue WHERE status = 'SETTLED') AS event_settled_volume,

    (SELECT COALESCE(SUM(reserved_balance),0) FROM wallets) AS reserved_total,

    (SELECT COALESCE(SUM(pending_balance),0) FROM wallets) AS pending_total,

    (SELECT COALESCE(SUM(settled_balance),0) FROM wallets) AS settled_total
FROM wallets
LIMIT 1;
