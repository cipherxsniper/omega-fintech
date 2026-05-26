-- HARD STOP IF DRIFT IS DETECTED IN PIPELINE

CREATE OR REPLACE FUNCTION enforce_consensus()
RETURNS trigger AS $$
DECLARE
    drift numeric;
BEGIN

    SELECT (
        NEW.settled_balance -
        COALESCE((
            SELECT SUM(
                CASE WHEN direction='CREDIT' THEN amount ELSE -amount END
            )
            FROM ledger_entries
            WHERE wallet_id = NEW.id
        ), 0)
    ) INTO drift;

    IF abs(drift) > 0 THEN
        RAISE EXCEPTION 'CONSENSUS FAILURE: WALLET DRIFT DETECTED %', drift;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
