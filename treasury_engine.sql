
CREATE TABLE IF NOT EXISTS treasury_state (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    total_liquidity NUMERIC(20,2) NOT NULL,
    reserved_liquidity NUMERIC(20,2) NOT NULL DEFAULT 0,
    available_liquidity NUMERIC(20,2) NOT NULL,
    updated_at TIMESTAMP DEFAULT now()
);


CREATE TABLE IF NOT EXISTS treasury_limits (
    wallet_id UUID PRIMARY KEY,
    max_exposure NUMERIC(20,2) NOT NULL,
    daily_limit NUMERIC(20,2) NOT NULL,
    current_exposure NUMERIC(20,2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMP DEFAULT now()
);

