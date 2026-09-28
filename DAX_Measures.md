# DAX Measures

```DAX
Total Customers = DISTINCTCOUNT(Customers[customer_id])
Total Accounts = DISTINCTCOUNT(Accounts[account_id])
Total Transactions = DISTINCTCOUNT(Transactions[transaction_id])
Total Transaction Amount = SUM(Transactions[amount])
Credit Amount = CALCULATE([Total Transaction Amount], Transactions[transaction_type] = "Credit")
Debit Amount = CALCULATE([Total Transaction Amount], Transactions[transaction_type] = "Debit")
Average Transaction Amount = AVERAGE(Transactions[amount])
Average Account Balance = AVERAGE(Accounts[balance])
Customer Transaction Count = DISTINCTCOUNT(Transactions[transaction_id])
Customer Account Balance = SUM(Accounts[balance])
```