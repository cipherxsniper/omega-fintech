CREATE TABLE IF NOT EXISTS consensus_drift_log (
    id BIGSERIAL PRIMARY KEY,
    wallet_id UUID,
    live_limit NUMERIC(20,2),
    replay_limit NUMERIC(20,2),
    delta NUMERIC(20,2),
    detected_at TIMESTAMP DEFAULT NOW()
);
