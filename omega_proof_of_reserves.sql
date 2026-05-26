CREATE OR REPLACE VIEW omega_proof_of_reserves AS

SELECT

(
SELECT COALESCE(SUM(total_capital),0)
FROM treasury_reserve
) AS treasury_backing,

(
SELECT COALESCE(SUM(settled_balance),0)
FROM wallets
) AS issued_liabilities,

(
SELECT COALESCE(SUM(credit_limit),0)
FROM credit_lines
) AS total_credit_exposure,

(
SELECT COALESCE(SUM(total_capital),0)
FROM treasury_reserve
)

- 

(
SELECT COALESCE(SUM(settled_balance),0)
FROM wallets
)

AS reserve_surplus;

