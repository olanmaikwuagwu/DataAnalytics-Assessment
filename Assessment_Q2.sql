-- Step 1. Retrieve customer id and name when the account is not deleted.

WITH all_users AS (
    SELECT 
        u.id AS user_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name
    FROM users_customuser u
    WHERE u.is_account_deleted = 0
),

-- Step 2. Get monthly count of savings deposits (inflow) transactions.

savings_monthly AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS trn_month,
        COUNT(*) AS inflow_trn
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, trn_month
),

-- Step 3. Get monthly count of withdrawal (outflow) transactions.

withdrawals_monthly AS (
    SELECT
        w.owner_id,
        DATE_FORMAT(w.transaction_date, '%Y-%m') AS trn_month,
        COUNT(*) AS outflow_trn
    FROM withdrawals_withdrawal w
    GROUP BY w.owner_id, trn_month
),

-- Step 4. Combine savings deposits and withdrawals.

combined_monthly_trn AS (
    -- Savings deposits side
    SELECT
        s.owner_id,
        s.trn_month,
        s.inflow_trn,
        COALESCE(w.outflow_trn, 0) AS outflow_trn
    FROM savings_monthly s
    LEFT JOIN withdrawals_monthly w 
        ON s.owner_id = w.owner_id AND s.trn_month = w.trn_month

    UNION ALL

    -- Withdrawal side (capture individuals who only withdrew but did not deposit in a month)
    SELECT
        w.owner_id,
        w.trn_month,
        0 AS inflow_trn,
        w.outflow_trn
    FROM withdrawals_monthly w
    LEFT JOIN savings_monthly s 
        ON w.owner_id = s.owner_id AND w.trn_month = s.trn_month
    WHERE s.owner_id IS NULL
),

-- Step 5. Sum transactions per month.

monthly_trn_totals AS (
    SELECT
        owner_id,
        trn_month,
        inflow_trn + outflow_trn AS monthly_trn
    FROM combined_monthly_trn
),

-- Step 6. Calculate average monthly transactions.

avg_trn_per_customer AS (
    SELECT
        owner_id,
        AVG(monthly_trn) AS avg_transactions_per_month
    FROM monthly_trn_totals
    GROUP BY owner_id
),

-- Step 7. Join with all users.

merged_data AS (
    SELECT 
        u.user_id,
        u.name,
        COALESCE(a.avg_transactions_per_month, 0) AS avg_transactions_per_month
    FROM all_users u
    LEFT JOIN avg_trn_per_customer a ON u.user_id = a.owner_id
),

-- Step 8. Categorize customers by frequency.

categories AS (
    SELECT
        m.user_id,
        m.name,
        m.avg_transactions_per_month,
        CASE
            WHEN m.avg_transactions_per_month <= 2 THEN 'Low Frequency'
            WHEN m.avg_transactions_per_month <= 9 THEN 'Medium Frequency'
            ELSE 'High Frequency'
        END AS frequency_category
    FROM merged_data m
)

-- Step 9. Final table with customer count and average monthly transactions categorized by frequency.

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_monthly_transactions
FROM categories
GROUP BY frequency_category
ORDER BY avg_monthly_transactions DESC;
