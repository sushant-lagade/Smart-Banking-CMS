# Tableau Dashboard Guide — Smart Banking CMS

## Data connection
Connect to the four CSV files. Use relationships:
- Customers.customer_id = Accounts.customer_id
- Banks.bank_id = Accounts.bank_id
- Accounts.account_id = Transactions.account_id

Prefer Tableau logical relationships or joins at the model layer and verify row counts after combining transaction-level data.

## Calculated fields
**Total Transaction Amount**
`SUM([amount])`

**Credit Amount**
`SUM(IF [transaction_type] = "Credit" THEN [amount] ELSE 0 END)`

**Debit Amount**
`SUM(IF [transaction_type] = "Debit" THEN [amount] ELSE 0 END)`

**Transaction Count**
`COUNT([transaction_id])`

**Account Balance**
`SUM([balance])`

## Dashboard 1 — Banking Overview
- KPI cards: COUNTD(customer_id), COUNTD(account_id), COUNTD(transaction_id), SUM(amount)
- Bar: Bank Name -> Columns; COUNTD(Account ID) -> Rows
- Donut/pie: Transaction Type -> Color; SUM(Amount) -> Angle
- Bar: City -> Rows; COUNTD(Customer ID) -> Columns
- Bar: Bank Name -> Rows; SUM(Amount) -> Columns
- Bar/pie: Account Type -> Color; COUNTD(Account ID) -> Angle
- Filters: Bank, City, Account Type, Transaction Type, Transaction Date

## Dashboard 2 — Customer Analysis
- Top customers by SUM(Amount)
- Transaction count by customer
- Account balance by customer
- Use a Top N filter parameter if desired.

## Dashboard 3 — Transaction Analysis
- Credit vs Debit
- Monthly transaction trend
- Bank-wise transaction amount
- Transaction count by transaction type

## Layout
Use KPI cards across the top, primary charts in the middle, and filters in a compact side panel. Keep labels readable and avoid unnecessary decoration.

## Interview explanation
"I used the same synthetic dataset in Tableau as a reporting practice component, built calculated fields, filters and dashboards, and compared the visual analysis with the Power BI view."
