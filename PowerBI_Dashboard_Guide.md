# Power BI Dashboard Guide — Smart Banking CMS

## Data sources
Import `banks.csv`, `customers.csv`, `accounts.csv`, and `transactions.csv`.

## Relationships
- Customers[customer_id] 1 -> * Accounts[customer_id]
- Banks[bank_id] 1 -> * Accounts[bank_id]
- Accounts[account_id] 1 -> * Transactions[account_id]

Use single-direction filtering from parent to child tables.

## DAX Measures
```DAX
Total Customers = DISTINCTCOUNT(Customers[customer_id])
Total Accounts = DISTINCTCOUNT(Accounts[account_id])
Total Transactions = DISTINCTCOUNT(Transactions[transaction_id])
Total Transaction Amount = SUM(Transactions[amount])
Credit Amount = CALCULATE([Total Transaction Amount], Transactions[transaction_type] = "Credit")
Debit Amount = CALCULATE([Total Transaction Amount], Transactions[transaction_type] = "Debit")
Average Transaction Amount = AVERAGE(Transactions[amount])
Average Account Balance = AVERAGE(Accounts[balance])
```

## Page 1 — Banking Overview
- KPI Cards: Total Customers, Total Accounts, Total Transactions, Total Transaction Amount.
- Clustered bar: Axis = Banks[bank_name], Values = [Total Accounts].
- Donut: Legend = Transactions[transaction_type], Values = [Total Transaction Amount].
- Column/bar: Axis = Customers[city], Values = [Total Customers].
- Bar: Axis = Banks[bank_name], Values = [Total Transaction Amount].
- Donut: Legend = Accounts[account_type], Values = [Total Accounts].
- Donut: Legend = Accounts[status], Values = [Total Accounts].
- Slicers: Bank, City, Account Type, Transaction Type, Transaction Date.

## Page 2 — Customer Analysis
- Table: customer name, transaction count, total transaction amount, account balance.
- Bar chart: Axis = customer name, Values = total transaction amount; visual filter Top N = 10.
- Bar chart: Axis = customer name, Values = transaction count.
- Bar chart: Axis = customer name, Values = account balance.

Optional measures:
```DAX
Customer Transaction Count = DISTINCTCOUNT(Transactions[transaction_id])
Customer Account Balance = SUM(Accounts[balance])
```

## Page 3 — Transaction Analysis
- Donut: transaction type vs total amount.
- Line chart: Axis = Transactions[transaction_date] (Month hierarchy), Values = [Total Transaction Amount].
- Column chart: Axis = transaction type, Values = [Total Transactions].
- Bar chart: Axis = bank name, Values = [Total Transaction Amount].
- Line chart: Axis = transaction date, Values = [Total Transactions].

## Interview explanation
"I loaded four CSV datasets, created one-to-many relationships, built DAX measures for KPIs, and created three pages for overview, customer analysis, and transaction trends."
