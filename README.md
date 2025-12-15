# Data Engineering Program - SQL DuckDB Course Lab Repository
## Project Overview
This project explores the Sakila DVD rental database using SQL, DuckDB, Python, and Evidence. The goal is to understand the data and find patterns in movies, customers, and revenue.

The data is loaded from a SQLite database into DuckDB, checked and explored in Python, and then shown in an interactive dashboard. The analysis looks at movie length, movie categories, customer spending, and how revenue is generated.

This project shows the full process of working with data: loading it, analyzing it, and presenting the results in a clear way.
```
SQL_LAB1_AIRA_FRANCO/
├── dashboard/
│   ├── pages/
│   │   ├── index.md               ← Dashboard home page
│   │   └── sakila.md              ← Sakila database page
│   └── sources/
│       ├── needful_things/        ← Evidence internal files (auto-generated)
│       └── sakila/                ← Database connection & query setup for Evidence
├── data/
│   ├── sakila.duckdb              ← Main database used for analysis
│   └── sqlite-sakila.db           ← Original source database
├── documentation
│   └── README.md                  ← How to set up and run the Sakila Project
├── sql/
│   └── load_sakila.sql            ← SQL used to load and prepare sakila data
├── load_sakila_sqlite_duckdb.py   ← Script to move sakila data from SQLite to DuckDB
├── duckdb_pandas.ipynb            ← Sakila data exploration with Pandas
├── test_sakila.ipynb              ← Basic data checks and tests
├── pyproject.toml                 ← Project dependencies and settings
└── README.md                      ← This file: Project overview and insights video

```

## Video explanation of insights
**DuckDB · Pandas · Evidence Dashboard**

[![Watch the video](https://img.youtube.com/vi/Bd35z9qoPdk/maxresdefault.jpg)](https://www.youtube.com/watch?v=Bd35z9qoPdk)

## Learning Outcomes
1. By completing this project and related exercises, I have learned to:

2. Learned foundational and advanced SQL concepts such as filtering, joins, aggregations, subqueries, and set operations. 

3. Explored working with temporal data, string functions, and advanced SQL constructs like CTEs and views. 

4. Applied window functions to solve more complex analytical queries. 

5. Connected SQL workflows with Python and Pandas for flexible data analysis. 

6. Built and validated a reproducible data pipeline from ingestion to analysis.

7. Used Evidence to build an interactive dashboard as code and operationalize insights. 

8. Practiced data quality checks and testing to ensure reliable results.


## Notes
- The dashboard/ folder contains the Evidence dashboard, including Node.js files (package.json, package-lock.json), page files, data sources, and dashboard-specific VS Code settings.

- The `sources/sakila/connection.yaml` file defines how Evidence connects to the DuckDB database.

- The `data/` folder stores both the original SQLite database and the DuckDB database used for analysis.

- A root-level `.vscode/settings.json` is included for consistent editor settings across the project.
