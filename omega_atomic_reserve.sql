CREATE OR REPLACE FUNCTION reserve_funds(
    p_wallet_id UUID,
    p_amount NUMERIC
)
RETURNS BOOLEAN AS $$
DECLARE
    v_available NUMERIC;
BEGIN

    SELECT (settled_balance - reserved_balance)
    INTO v_available
    FROM wallets
    WHERE id = p_wallet_id
    FOR UPDATE;

    IF v_available < p_amount THEN
        RETURN FALSE;
    END IF;

    UPDATE wallets
    SET reserved_balance = reserved_balance + p_amount
    WHERE id = p_wallet_id;

    RETURN TRUE;

END;
$$ LANGUAGE plpgsql;
