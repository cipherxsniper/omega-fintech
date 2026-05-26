
-- remove ambiguity column if unused in runtime path
ALTER TABLE virtual_cards
DROP COLUMN IF EXISTS spending_limit;

-- ensure enforceable constraint clarity
ALTER TABLE virtual_cards
ALTER COLUMN spendable_limit SET NOT NULL;

ALTER TABLE virtual_cards
ALTER COLUMN spendable_limit SET DEFAULT 0;

