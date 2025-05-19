# DataAnalytics-Assessment
 The following are the approaches adopted while solving these questions:
 
 Question 1. Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

   * Use common table expression to segment and merge queries. Assume total deposits as the sum of confirmed amount in 
     the savings table.
   * Group account type as savings or investment using the CASE WHEN logic. According to the hint, savings_plan is taken as 
     is_regular_savings = 1 while investment plan is taken as is_a_fund = 1.
   * Concatenate the first and last name of customers to obtain name information.
   * Since customers must have one funded savings plan and one funded investment, return the table when the count of plans with 
     funds is equal to or greater than one.

Challenge: 
    The challenge encountered in this question is being sure that the sum of confirmed amount from the savings table also 
    covers funding for investment. Since the plan types fall under the savings table, I classified the confirmed amount as 
    overall deposit.

Question 2.  Calculate the average number of transactions per customer per month and categorize them:
         "High Frequency" (≥10 transactions/month)
         "Medium Frequency" (3-9 transactions/month)
          "Low Frequency" (≤2 transactions/month)

   *   Define transactions in terms of inflows and outflows. That is, deposits and withdrwals.
   *   From the users table, obtain data about customer id and name.
   *   Assume deposits as confirmed amount greater than 0.
   *   Assume withdrawals as amount withdrawn greater than 0.
   *   Sum monthly inflows and outflows.
   *   Determine average monthly transactions and group by frequency criteria.
   *   Retrieve the final table with the frequency categories, customer counts, and average monthly transactions.

Challenge: 
  I was uncertain about all the real indicators of transactions. So, I narrowed the definition of transactions to deposits 
  and withdrawals. I had to use the withdrawals table to get amount withdrawn even though the table was not included under 
  tasks.

Question 3. Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .

  *   Extract data about owner and plan id.
  *   Use CASE WHEN to categorize account type as savings or investment.
  *   Assume last transaction date as the latest transaction date in the savings table or the withdrawal date in the 
      plans_plan table.
  *   Consider only active accounts using status_id = 1.
  *   No transactions is defined as confirmed amount = 0.
  *   Let the range of last transaction date fall within the past 365 days.

Challenge:
   I had a little challenge identifying what qualifies as the last transaction date. To resolve this, I reasoned that the 
   most current day customers deposited and the most current day they withdrew their investments could be classified as the 
   last transaction date.

Question 4. For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
      Account tenure (months since signup)
      Total transactions
      Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
      Order by estimated CLV from highest to lowest

 *   Determine the customer id and name.
 *   Assume tenure months as the month difference between the date of account creation and the last transaction date.
 *   Count all ids as total transactions.
 *   Divide total transactions by the tenure months, multiply by 12, 0.001, and the transaction value.
