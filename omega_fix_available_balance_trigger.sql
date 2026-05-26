CREATE OR REPLACE FUNCTION omega_update_available_balance()
RETURNS TRIGGER AS $$
BEGIN

    NEW.available_balance :=
        COALESCE(NEW.settled_balance, 0)
        - COALESCE(NEW.reserved_balance, 0)
        - COALESCE(NEW.locked_balance, 0);

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;
