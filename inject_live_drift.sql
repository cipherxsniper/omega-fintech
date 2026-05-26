UPDATE credit_policy_state
SET current_limit = current_limit + 777777
WHERE wallet_id = (
    SELECT wallet_id
    FROM credit_policy_state
    LIMIT 1
);
