-- REAL-TIME FRAUD SIGNATURE OBSERVABILITY

CREATE OR REPLACE VIEW v_fraud_signatures AS
SELECT
    wallet_id,

    COUNT(*) FILTER (
        WHERE created_at > now() - interval '10 minutes'
    ) AS tx_velocity,

    SUM(
        CASE WHEN direction='CREDIT' THEN amount ELSE amount END
    ) AS volume_10m,

    CASE
        WHEN COUNT(*) > 10 THEN 'VELOCITY_ANOMALY'
        WHEN SUM(amount) > 5000 THEN 'VOLUME_ANOMALY'
        ELSE 'NORMAL'
    END AS risk_class

FROM ledger_entries
GROUP BY wallet_id;
