CREATE TYPE authorization_state AS ENUM (
'AUTHORIZED',
'CAPTURED',
'SETTLED',
'REVERSED',
'EXPIRED',
'CHARGEBACK'
);

ALTER TABLE payment_authorizations
ADD COLUMN IF NOT EXISTS lifecycle_state authorization_state
DEFAULT 'AUTHORIZED';

CREATE INDEX IF NOT EXISTS idx_payment_authorizations_lifecycle
ON payment_authorizations(lifecycle_state);

