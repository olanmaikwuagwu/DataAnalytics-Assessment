-- Identify user ids, customer names, number of months spent, total transactions and estimated clv.

SELECT
	u.id AS customer_id,
	CONCAT(u.first_name, " ", u.last_name) AS name,
	TIMESTAMPDIFF(MONTH, u.created_on, MAX(DATE(s.transaction_date))) AS tenure_months,
	COUNT(s.id) AS total_transactions, 
	ROUND(
	(COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.created_on, MAX(DATE(s.transaction_date))), 0))
	* 12
	* 0.001
	* COALESCE(AVG(s.confirmed_amount), 0), 2)  AS estimated_clv
FROM 
users_customuser u
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE u.is_account_deleted = 0
AND u.is_active = 1
GROUP BY 
u.id, u.name, u.created_on
ORDER BY estimated_clv DESC;
