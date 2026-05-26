-- BLOCK ALL DIRECT MUTATIONS (HARD SAFETY LAYER)

CREATE OR REPLACE FUNCTION block_direct_wallet_update()
RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION 'DIRECT WALLET MUTATION DISABLED — USE EVENT LEDGER';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS wallet_direct_block ON wallets;

CREATE TRIGGER wallet_direct_block
BEFORE UPDATE ON wallets
FOR EACH ROW
WHEN (
    OLD.settled_balance IS DISTINCT FROM NEW.settled_balance
    OR OLD.reserved_balance IS DISTINCT FROM NEW.reserved_balance
)
EXECUTE FUNCTION block_direct_wallet_update();
