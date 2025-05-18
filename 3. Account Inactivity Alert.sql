SELECT
    s.owner_id,
    s.plan_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE NULL
    END AS type,
    COALESCE(MAX(DATE(s.transaction_date)), DATE(p.withdrawal_date)) AS last_transaction_date, /* Checks the last transaction
dates in the savings and plans tables. */
    DATEDIFF(
        CURDATE(),
        COALESCE(MAX(DATE(s.transaction_date)), DATE(p.withdrawal_date))
    ) AS inactivity_days  -- Check the number of days between the current date and the last transaction date
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
WHERE
    
    -- Only active accounts
    
    p.status_id = 1
    AND s.verification_status_id = 1
    
    -- Consider only accounts with no inflow (confirmed_amount = 0)
    
    AND (s.confirmed_amount = 0 OR s.confirmed_amount IS NULL)
    AND (p.is_a_fund = 1 OR p.is_regular_savings = 1)
    AND s.transaction_date >= CURDATE() - INTERVAL 365 DAY  -- Check within the past 365 days
GROUP BY 
    s.owner_id,
    s.plan_id,
    p.is_regular_savings,
    p.is_a_fund,
    p.withdrawal_date
HAVING inactivity_days > 0  -- Flag accounts with no transaction within the last 365 days
