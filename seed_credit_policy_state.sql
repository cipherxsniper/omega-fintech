INSERT INTO credit_policy_state (
    wallet_id,
    current_limit,
    state
)
SELECT
    id,
    ABS(settled_balance),
    'ACTIVE'
FROM wallets
ON CONFLICT (wallet_id)
DO NOTHING;
