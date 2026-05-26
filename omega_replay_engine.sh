#!/bin/bash

echo "🧠 OMEGA REPLAY ENGINE STARTING"

psql -U omega -d omega_bank <<SQL

-- SAFE EVENT REPLAY CORE
DO $$
DECLARE r RECORD;
BEGIN

    FOR r IN
        SELECT * FROM settlement_queue
        WHERE status IN ('PENDING','FAILED')
        ORDER BY created_at ASC
    LOOP

        -- mark processing safely
        UPDATE settlement_queue
        SET status = 'PROCESSING',
            processing_at = NOW(),
            retry_count = retry_count + 1
        WHERE id = r.id;

    END LOOP;

END $$;

SQL

echo "✅ REPLAY COMPLETE"
