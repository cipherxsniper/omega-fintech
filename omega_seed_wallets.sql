INSERT INTO wallet_registry (alias, wallet_id)
VALUES
('walletA', gen_random_uuid()),
('walletB', gen_random_uuid())
ON CONFLICT (alias) DO NOTHING;
