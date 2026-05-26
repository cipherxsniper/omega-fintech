
CREATE TABLE IF NOT EXISTS clearing_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    status TEXT NOT NULL,
    window_start TIMESTAMP NOT NULL,
    window_end TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);


CREATE TABLE IF NOT EXISTS clearing_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID NOT NULL,
    wallet_id UUID NOT NULL,
    amount NUMERIC(20,2) NOT NULL,
    direction TEXT NOT NULL,
    transaction_id UUID NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

