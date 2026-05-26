ALTER TABLE settlement_queue
ADD COLUMN IF NOT EXISTS retry_count INTEGER NOT NULL DEFAULT 0;

ALTER TABLE settlement_queue
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT now();

CREATE INDEX IF NOT EXISTS idx_settlement_retry
ON settlement_queue(status, retry_count);

