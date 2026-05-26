-- FRAUD SIGNAL HOOK FOR EXECUTION COORDINATOR

CREATE OR REPLACE FUNCTION fraud_risk_signal(wallet uuid)
RETURNS INTEGER AS $$
DECLARE
    score INTEGER;
BEGIN

    SELECT
        CASE
            WHEN COUNT(*) > 10 THEN 80
            WHEN SUM(amount) > 5000 THEN 90
            ELSE 0
        END
    INTO score
    FROM ledger_entries
    WHERE wallet_id = wallet
      AND created_at > now() - interval '10 minutes';

    RETURN COALESCE(score, 0);
END;
$$ LANGUAGE plpgsql;
