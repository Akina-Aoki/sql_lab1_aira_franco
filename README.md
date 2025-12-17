# Data Engineering Program - SQL DuckDB Course Lab Repository
## Project Overview
This project explores the Sakila DVD rental database using SQL, DuckDB, Python, and Evidence. The goal is to understand the data and find patterns in movies, customers, and revenue.

The data is loaded from a SQLite database into DuckDB, checked and explored in Python, and then shown in an interactive dashboard. The analysis looks at movie length, movie categories, customer spending, and how revenue is generated.

This project shows the full process of working with data: loading it, analyzing it, and presenting the results in a clear way.
```
SQL_LAB1_AIRA_FRANCO/
├── assets/
│   └── sakila_erd.png              ← Sakila database ERD image
├── dashboard/
│   ├── pages/                      ← Analysis pages
│   │   ├── index.md                ← Dashboard home page
│   │   ├── 1_revenue_film.md
│   │   ├── 2_revenue_genre.md
│   │   ├── 3_ranking.md
│   │   ├── 4_daily_price_distribution.md
│   │   ├── 5_runtime_revenue.md
│   │   └── other_sakila.md
│   └── sources/
│       ├── needful_things/         ← DO NOT TOUCH (auto-generated)
│       └── sakila/                 ← Database connection & query setup for Evidence
├── data/
│   ├── sakila.duckdb               ← Main database used for analysis
│   └── sqlite-sakila.db            ← Original source database
├── documentation/
│   └── README.md                   ← How to set up and run the Sakila Project
├── sql/
│   └── load_sakila.sql             ← SQL used to load and prepare Sakila data
├── load_sakila_sqlite_duckdb.py    ← Script to move Sakila data from SQLite to DuckDB
├── duckdb_pandas.ipynb             ← Sakila data exploration with Pandas
├── test_sakila.ipynb               ← Basic data checks and tests
├── pyproject.toml                  ← Project dependencies and settings
└── README.md                       ← Project overview and insights video
```
![Sakila Database](assets/sakila_erd.png)


## Video explanation of insights
**DuckDB · Pandas · Evidence Dashboard**

[![Watch the video](https://img.youtube.com/vi/1XSb0SXZ-V4/maxresdefault.jpg)](https://www.youtube.com/watch?v=1XSb0SXZ-V4)


## Learning Outcomes
- Use SQL for joins, filters, calculations, CTEs, and window functions
- Work with analytical calculations, text data, and more complex queries
- Do calculations to answer real analysis questions
- Combine SQL with Python and Pandas for data analysis
- Build a data pipeline from loading data to final results
- Create an interactive dashboard using Evidence
- Check data quality to make sure results are correct

## Notes
- The dashboard/ folder contains the Evidence dashboard, including Node.js files (package.json, package-lock.json), page files, data sources, and dashboard-specific VS Code settings.

- The `sources/sakila/connection.yaml` file defines how Evidence connects to the DuckDB database.

- The `data/` folder stores both the original SQLite database and the DuckDB database used for analysis.

- A root-level `.vscode/settings.json` is included for consistent editor settings across the project.
