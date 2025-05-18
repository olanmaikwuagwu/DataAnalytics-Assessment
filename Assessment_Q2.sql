-- This CTE groups customers according to their transaction frequencies.

-- Step 1. Retrieve customer id and name when the account is not deleted.

WITH all_users AS (
    SELECT 
        u.id AS user_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name
    FROM users_customuser u
    WHERE u.is_account_deleted = 0
),

-- Step 2. Get the count of monthly transactions.

monthly_transactions AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS trn_month,
        COUNT(*) AS monthly_trn
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, trn_month
),

-- Step 3. Determine average monthly transactions.

avg_trn_per_customer AS (
    SELECT
        owner_id,
        AVG(monthly_trn) AS avg_transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),

-- Step 4. Identify all users and their monthly transactions.

merged_data AS (
    SELECT 
        u.user_id,
        u.name,
        COALESCE(a.avg_transactions_per_month, 0) AS avg_transactions_per_month
    FROM all_users u
    LEFT JOIN avg_trn_per_customer a ON u.user_id = a.owner_id
),

-- Step 5. Group by transaction frequencies.

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

-- Step 6. Return a table with customer count and average monthly transactions categorized by frequency.

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_monthly_transactions
FROM categories
GROUP BY frequency_category
ORDER BY avg_monthly_transactions DESC;
