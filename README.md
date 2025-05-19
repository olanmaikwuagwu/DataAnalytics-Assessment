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
    covers funding for investment. 

Question 2.  Calculate the average number of transactions per customer per month and categorize them:
         "High Frequency" (≥10 transactions/month)
         "Medium Frequency" (3-9 transactions/month)
          "Low Frequency" (≤2 transactions/month)

   *   Define transactions in terms of inflows and outflows. That is, deposits and withdrwals.
   *   From the users table, obtain data about customer id and name.
   *   Assume deposits as confirmed amount greater than 0.
   *   Assume withdrawals as amount withdrawn greater than 0.  
