CREATE OR REPLACE FUNCTION apply_settlement_event()
RETURNS void AS $$
DECLARE
    e RECORD;
BEGIN
    FOR e IN
        SELECT * FROM settlement_queue
        WHERE status = 'PENDING'
        ORDER BY created_at ASC
        FOR UPDATE SKIP LOCKED
    LOOP

        -- mark processing
        UPDATE settlement_queue
        SET status = 'PROCESSING',
            processing_at = NOW()
        WHERE id = e.id;

        -- apply balance change deterministically
        UPDATE wallets
        SET settled_balance = settled_balance + e.amount,
            reserved_balance = GREATEST(reserved_balance - e.amount, 0)
        WHERE id = e.wallet_id;

        -- finalize event
        UPDATE settlement_queue
        SET status = 'SETTLED'
        WHERE id = e.id;

    END LOOP;
END;
$$ LANGUAGE plpgsql;
