```sql

---- 1. Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits. ----

  
WITH savings AS(	
	SELECT owner_id,
    SUM(confirmed_amount) AS total_deposit
    FROM savings_savingsaccount
    WHERE confirmed_amount IS NOT NULL
    GROUP BY owner_id
),
investments AS (
	SELECT owner_id,
		COUNT(CASE WHEN is_regular_savings = 1 THEN 1 END) AS savings_count,
		COUNT(CASE WHEN is_a_fund = 1 THEN 1 END) AS investment_count
    FROM plans_plan p
    WHERE p.amount != 0
    GROUP BY owner_id
),
customer_info AS (
    SELECT 
      cu.id AS owner_id,
      CONCAT(cu.first_name, " ", cu.last_name) AS name,
      COALESCE(i.savings_count, 0) AS savings_count,
      COALESCE(i.investment_count, 0) AS investment_count,
      COALESCE(s.total_deposit, 0) AS total_deposits
      FROM users_customuser cu
      LEFT JOIN investments i ON cu.id = i.owner_id
      LEFT JOIN savings s ON cu.id = s.owner_id
)

SELECT * 
FROM customer_info
 WHERE savings_count >= 1
 AND investment_count >= 1
 ORDER BY total_deposits DESC;

  

```
