USE smart_banking_cms;

-- BASIC
SELECT * FROM Customers;
SELECT * FROM Accounts WHERE status='Active';
SELECT * FROM Accounts ORDER BY balance DESC;
SELECT * FROM Transactions LIMIT 20;
SELECT DISTINCT city FROM Customers ORDER BY city;

-- AGGREGATES
SELECT COUNT(*) AS total_customers FROM Customers;
SELECT SUM(amount) AS total_transaction_amount FROM Transactions;
SELECT AVG(amount) AS avg_transaction_amount FROM Transactions;
SELECT MIN(amount) AS min_transaction_amount, MAX(amount) AS max_transaction_amount FROM Transactions;

-- GROUP BY
SELECT bank_id, COUNT(*) AS account_count FROM Accounts GROUP BY bank_id ORDER BY account_count DESC;
SELECT city, COUNT(*) AS customer_count FROM Customers GROUP BY city ORDER BY customer_count DESC;
SELECT transaction_type, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM Transactions GROUP BY transaction_type;

-- HAVING
SELECT account_id, SUM(amount) AS total_transaction_amount
FROM Transactions GROUP BY account_id HAVING SUM(amount) > 200000;
SELECT customer_id, COUNT(*) AS transaction_count
FROM Customers c JOIN Accounts a ON c.customer_id=a.customer_id
JOIN Transactions t ON a.account_id=t.account_id
GROUP BY customer_id HAVING COUNT(*) > 5;

-- JOINS
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       a.account_id, a.account_number, a.balance
FROM Customers c INNER JOIN Accounts a ON c.customer_id=a.customer_id;

SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       a.account_number, t.transaction_date, t.transaction_type, t.amount
FROM Customers c
JOIN Accounts a ON c.customer_id=a.customer_id
JOIN Transactions t ON a.account_id=t.account_id;

SELECT b.bank_name, a.account_id, a.account_number, a.balance
FROM Banks b INNER JOIN Accounts a ON b.bank_id=a.bank_id;

SELECT b.bank_name, a.account_number, t.transaction_type, t.amount, t.transaction_date
FROM Banks b JOIN Accounts a ON b.bank_id=a.bank_id
JOIN Transactions t ON a.account_id=t.account_id;

SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name, a.account_number
FROM Customers c LEFT JOIN Accounts a ON c.customer_id=a.customer_id;

-- SUBQUERIES
SELECT * FROM Accounts WHERE balance > (SELECT AVG(balance) FROM Accounts);
SELECT * FROM Accounts WHERE balance=(SELECT MAX(balance) FROM Accounts);
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name
FROM Customers c
WHERE c.customer_id IN (
  SELECT a.customer_id FROM Accounts a JOIN Transactions t ON a.account_id=t.account_id
  WHERE t.amount > 50000
);

-- CTE
WITH customer_balance AS (
 SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        SUM(a.balance) AS total_balance
 FROM Customers c JOIN Accounts a ON c.customer_id=a.customer_id
 GROUP BY c.customer_id, customer_name
)
SELECT * FROM customer_balance ORDER BY total_balance DESC;

WITH customer_txn AS (
 SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        COUNT(t.transaction_id) AS transaction_count,
        COALESCE(SUM(t.amount),0) AS total_transaction_amount
 FROM Customers c JOIN Accounts a ON c.customer_id=a.customer_id
 LEFT JOIN Transactions t ON a.account_id=t.account_id
 GROUP BY c.customer_id, customer_name
)
SELECT * FROM customer_txn ORDER BY total_transaction_amount DESC;

-- WINDOW FUNCTIONS
SELECT account_id, balance,
 ROW_NUMBER() OVER (ORDER BY balance DESC) AS row_num,
 RANK() OVER (ORDER BY balance DESC) AS balance_rank,
 DENSE_RANK() OVER (ORDER BY balance DESC) AS dense_balance_rank
FROM Accounts;

SELECT account_id, transaction_date, amount,
 SUM(amount) OVER (PARTITION BY account_id ORDER BY transaction_date, transaction_id
 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Transactions;

-- DATA QUALITY
SELECT transaction_id, COUNT(*) AS duplicate_count
FROM Transactions GROUP BY transaction_id HAVING COUNT(*)>1;
SELECT COUNT(*) AS null_amounts FROM Transactions WHERE amount IS NULL;
SELECT COUNT(*) AS invalid_transaction_types
FROM Transactions WHERE transaction_type NOT IN ('Credit','Debit');
SELECT COUNT(*) AS invalid_account_types
FROM Accounts WHERE account_type NOT IN ('Savings','Current','Salary');

-- BUSINESS ANALYSIS
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       SUM(t.amount) AS total_transaction_amount
FROM Customers c JOIN Accounts a ON c.customer_id=a.customer_id
JOIN Transactions t ON a.account_id=t.account_id
GROUP BY c.customer_id, customer_name
ORDER BY total_transaction_amount DESC LIMIT 10;

SELECT * FROM Accounts ORDER BY balance DESC LIMIT 10;

SELECT b.bank_name, SUM(t.amount) AS transaction_amount
FROM Banks b JOIN Accounts a ON b.bank_id=a.bank_id
JOIN Transactions t ON a.account_id=t.account_id
GROUP BY b.bank_id,b.bank_name ORDER BY transaction_amount DESC;

SELECT transaction_type, SUM(amount) AS total_amount
FROM Transactions GROUP BY transaction_type;

SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       COUNT(t.transaction_id) AS transaction_count
FROM Customers c JOIN Accounts a ON c.customer_id=a.customer_id
JOIN Transactions t ON a.account_id=t.account_id
GROUP BY c.customer_id, customer_name ORDER BY transaction_count DESC;

SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       SUM(t.amount) AS total_transaction_amount
FROM Customers c JOIN Accounts a ON c.customer_id=a.customer_id
JOIN Transactions t ON a.account_id=t.account_id
GROUP BY c.customer_id, customer_name ORDER BY total_transaction_amount DESC;

SELECT city, COUNT(*) AS customer_count FROM Customers GROUP BY city ORDER BY customer_count DESC;
SELECT account_type, COUNT(*) AS account_count FROM Accounts GROUP BY account_type;
SELECT status, COUNT(*) AS account_count FROM Accounts GROUP BY status;

SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month,
       COUNT(*) AS transaction_count, SUM(amount) AS transaction_amount
FROM Transactions GROUP BY month ORDER BY month;
