# 📊 Electronics Retail Analysis

A data analysis project for a **global electronics retailer**. Raw CSV data is loaded into a dimensional model in **SQL Server (T-SQL)**, a date dimension is generated with **Power Query**, KPIs and exploratory data analysis (EDA) are computed via SQL, and the results are visualized in a **Power BI** dashboard.

## 🧱 Project flow

```
CSV (datasets/) 
   │
   ▼
Staging tables (stg_*)  ──►  ddl.sql
   │
   ▼
Dimensional model (dim*, sales)  ──►  load_sql (stored procedure: load_tables)
   │
   ▼
Fact view: factsales  ──►  vw_factsales.sql
   │
   ├──►  Date dimension (dimdate.pq) ── Power Query
   ├──►  EDA / KPIs (eda_analysis.sql)
   └──►  Interactive dashboard (Power BI/Global_Electronics_Analysis.pbix)
```

## 🗂️ Repository structure

```
electronics_retail_analysis/
├── datasets/
│   ├── Customers.csv          # ~15,266 customers
│   ├── Products.csv           # ~2,517 products
│   ├── Sales.csv              # ~62,884 sales lines
│   ├── Stores.csv             # 67 stores
│   ├── Exchange_Rates.csv     # ~11,215 exchange rate records
│   └── Data_Dictionary.csv    # Data dictionary for all tables
│
├── scripts/
│   ├── ddl.sql                          # Creates staging and dimensional tables
│   ├── load_sql                         # Stored procedure load_tables (BULK INSERT + cleaning)
│   ├── vw_factsales.sql                 # factsales view (sales amount and cost in USD)
│   ├── dimdate.pq                       # Date dimension (Power Query / M)
│   └── Exploratory Data Analysis/
│       └── eda_analysis.sql             # KPIs, trends, product rankings
│
├── Power BI/
│   └── Global_Electronics_Analysis.pbix # Interactive dashboard
│
├── LICENSE                              # MIT
└── README.md
```

## 📁 Datasets

The data follows the classic **Global Electronics Retailer** dataset model:

| Table | Approx. rows | Content |
|---|---|---|
| `Customers.csv` | 15,266 | Demographics: gender, name, city, state, country, continent, birthday |
| `Products.csv` | 2,517 | Product, brand, color, unit cost/price (USD), category and subcategory |
| `Sales.csv` | 62,884 | Order line: order/delivery dates, customer, store, product, quantity, currency |
| `Stores.csv` | 67 | Store, country, state, square meters, open date |
| `Exchange_Rates.csv` | 11,215 | Daily exchange rate per currency relative to USD |
| `Data_Dictionary.csv` | — | Field-level description for all the tables above |

## 🛠️ Scripts

- **`ddl.sql`** – Defines the staging tables (`stg_dimcustomer`, `stg_dimproduct`, `stg_dimstores`, `stg_dimexcrates`, `stg_sales`) and their final, properly typed counterparts (dates as `DATE`, amounts as `DECIMAL`, etc.).
- **`load_sql`** – Stored procedure `load_tables` that:
  - Loads each CSV into its staging table via `BULK INSERT`.
  - Cleans and casts the data types (dates, prices with `$` and commas, etc.).
  - Inserts the cleaned data into the final tables.
  - ⚠️ The CSV paths are hardcoded to `C:\SQL_projects\global_Electronics_retailer\...`; update them to match your environment before running.
- **`vw_factsales.sql`** – Creates the `factsales` view, joining `sales` with `dimproduct` and `dimexcrates` to compute `Sales_Amount_USD` and `COGS_USD` per sales line.
- **`dimdate.pq`** – Power Query (M) script that generates a full calendar table (year, month, month name, quarter) from the date range in `sales`.
- **`Exploratory Data Analysis/eda_analysis.sql`** – Exploratory analysis queries:
  - Global KPIs: total quantity, total sales, average price, total margin and margin %, number of orders/customers/products and their averages.
  - Month-over-month sales with variance vs. the previous month.
  - Running totals and 6-month moving average.
  - Top-10 products by revenue (using both `TOP` and `RANK() OVER`).

## 📊 Power BI

`Power BI/Global_Electronics_Analysis.pbix` contains the final dashboard, built on top of the dimensional model and the `factsales` view, visualizing sales, margins, time trends, and product/store/customer performance.

<img width="1332" height="790" alt="image" src="https://github.com/user-attachments/assets/93618403-2cdf-471e-91a3-713c19b46138" />

## 🚀 How to reproduce this project

1. Clone the repository and create a database in SQL Server.
2. Run `scripts/ddl.sql` to create the staging and dimensional tables.
3. Edit the file paths in `scripts/load_sql` to point to your local `datasets/` folder.
4. Execute the `load_tables` stored procedure to load and clean the data.
5. Run `scripts/vw_factsales.sql` to create the fact view.
6. Run `scripts/Exploratory Data Analysis/eda_analysis.sql` to get the KPIs and exploratory analysis.
7. (Optional) Import `scripts/dimdate.pq` as a Power Query if you're building your own Power BI model.
8. Open `Power BI/Global_Electronics_Analysis.pbix` with Power BI Desktop to explore the dashboard.

## 🛠️ Tech stack

- **T-SQL (SQL Server)** – data modeling, loading (BULK INSERT), views, and EDA with window functions.
- **Power Query (M)** – date dimension generation.
- **Power BI** – final dashboard.

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

## 👤 Author

**Mario R.** ([MariorData](https://github.com/MariorData))

---

*If you have suggestions or find an issue, feel free to open an issue or a pull request.*
