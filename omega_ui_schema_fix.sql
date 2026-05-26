-- FIX CONTROL PLANE OBSERVABILITY QUERIES

-- FIX 1: invariant_failures column mismatch
-- event_type DOES NOT EXIST → use "type"

-- SAFE QUERY REPLACEMENT:
-- SELECT type, status, created_at FROM invariant_failures;

-- OPTIONAL CLEAN VIEW FOR UI:
CREATE OR REPLACE VIEW v_invariant_failures_ui AS
SELECT
    type AS event_type,
    status,
    created_at
FROM invariant_failures;
