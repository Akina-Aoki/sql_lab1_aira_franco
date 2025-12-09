# sql_lab1_aira_franco
Data Engineering SQL DuckDB course Lab 1 repository

SQL_LAB1_AIRA_FRANCO/
│
├── data/
│   ├── sakila.duckdb
│   └── sqlite-sakila.db
│
├── sql/
│   └── load_sakila.sql
│
├── load_sakila_sqlite_duckdb.py   ← Python ETL script
├── duckdb_pandas.ipynb            ←  Jupyter notebook for SQL LAB analysis
├── test_sakila.ipynb              ←  Jupyter notebook to test Sakila load
└── README.md                      ← this file

Option 1: youtube channel (low resolution)<br>

[![DuckDB Course Project: SQL Queries on Pandas Dataframe](https://img.youtube.com/vi/mrcQrJ5y4LE/0.jpg)](https://www.youtube.com/watch?v=mrcQrJ5y4LE)

Option 2: Learnpoint (Recommend)
https://stise-my.sharepoint.com/:v:/g/personal/aira_franco_stud_sti_se/EcYp-EKQScFKt9A1EgHRklYBSu1_10an7CziRc3gUFpgnA?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=rZigHc

# Workflow Documentation for Task VG: 19_DLT

## 1. check for uv init
```
uv pip list
```
if no pyproject.toml existsm need to do the following steps for the set up
(Follow lecture 19_dlt)

## 2. Install uv init.

```
uv init
```

## 3. `pyproject.toml`
Go to `pyproject.toml` and change the `name = "dlt_sakila"`
Packages will be installed. One of them is `pyproject.toml`

## 4. ´uv add ipykernel "dlt[sql_database]"´ in terminal
It wil install the packages

## 5. Create a `load_sakila_sqlite_duckdb.py`
Go in the file.

```
import dlt
from dlt.sources.sql_database import sql_database
from pathlib import Path

SQLITE_PATH = Path(__file__).parent / "sqlite-sakila.db"
DUCKDB_PATH = Path(__file__).parent / "sakila.duckdb"


source = sql_database(credentials=f"sqlite:///{SQLITE_PATH}", schema="main")

# pipeline writing to a DuckDB file
pipeline = dlt.pipeline(
    pipeline_name="sakila_sqlite_to_duckdb",
    destination=dlt.destinations.duckdb(str(DUCKDB_PATH)),
    dataset_name="staging",
)

# run the load (this captures ALL tables automatically)
load_info = pipeline.run(source, write_disposition="replace")

print(load_info)
```

## 6. Install dlt in terminal
```
uv add "dlt[duckdb]"
```

## 7. Run the scripts in terminal
```
uv run python load_sakila_sqlite_duckdb.py`
```

```
uv add pandas
```

## 8. Create a jupyter notebook `test_sakila.ipynb`
In this part, also change to my venv.
Check the notebook to see the code that Sakila is correctly done.

___________________________________________________________________________________________________________________

# Workflow Documentation for Task VG: 20_evidence_dashboard



```
```
```
```