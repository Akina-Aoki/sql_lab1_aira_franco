# sql_lab1_aira_franco
Data Engineering SQL DuckDB course Lab 1 repository
```
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
└── README.md                      ←  Documentations for: Setting up the workflow
```

Option 1: youtube channel (low resolution)<br>

[![DuckDB Course Project: SQL Queries on Pandas Dataframe](https://img.youtube.com/vi/mrcQrJ5y4LE/0.jpg)](https://www.youtube.com/watch?v=mrcQrJ5y4LE)

Option 2: Learnpoint (Recommend) <br>
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

## 1. Nodejs installation
- Install nodejs in your local machine if you don't have it yet.
- If you have done once before, run in VSCode terminal to check if you have nodejs installed.

```
node -v
```
- Output: v22.21.1

```
 npm -v
```
Outoput: 10.9.4

## 2. The duckdb file
- Get the duckdb file from Kaggle and save it under `data` folder.
- Based on the ingestion script you shared, the pipeline writes exactly here:
```
DATA_PATH = Path(__file__).parent / "data"
SQLITE_PATH = DATA_PATH / "sqlite-sakila.db"
DUCKDB_PATH = DATA_PATH / "sakila.duckdb"
```

- This means the database lives here: `data/sakila.duckdb`
### Run to check the sakila.duckdb file in the terminal. 
```
duckdb data/sakila.duckdb
```

- Should see the database loaded in the terminal.
- Close the duckdb terminal once confrimed.
```
desc;
```
## 3. Evidence Dashboard creation
- Create a folder named `dashboard` in the root directory. Within that folder, you will build your dashboard application.
```
mkdir dashboard
```

And then cd into it
```
cd dashboard
```

- CTRL + SHIFT + P and Look for `Evidence Dashboard: Create New Project`
- Choose DASHBOARD as the folder to work on.
- It will create the files needed for the dashboard in a new VSCode window.


## 4. Working in the DASHBOARD

- In the .gitignore, add `.evidence`
- Save the file.

- Install different packages. Go to the path you want to install in. This case, it's in my dashboard folder for my lab.
```
npm install
```

and remeber, this is where I had an error that Debbie fixed to poppulate my evidence dashboard.
```
npm run sources
```

## 5. Add data sources
- There are 2 subfolder (pages, sources)
- Create a `sakila` folder under sources.
- Copy the available connection.yaml from `needful things` towards under the sakila folder.


- Double check if I have edited the connection.yaml.
- That file is written by DLT ingestion pipeline (as confirmed in Python script). If Evidence keeps reading the root-level file, will get an empty catalog.
Connection.yaml and sakila should always be in the same folder.


```
# 6. This file was automatically generated
name: sakila # adjusted to sakila database
type: duckdb
options:
  filename: data/sakila.duckdb 
  # adjusted to data/sakila database since file lives there
  # Without this adjustment, dashboards will operate on an empty environment
```

## 7. Run the dashboard
Open terminal on the dashboard folder and run:

```
npm run dev
```
The dashboard will be live at http://localhost:3000
More tutorials on Evidence Dashboard can be found at Kokchuns repo / Youtube channel.

## 8. About the sakila.duckdb database placement

Configuration must align with storage architecture.

The pattern is identical; the path changes depending on where it's placed the file.

Case A. If the database file is in /data (best practice)

```
/data/sakila.duckdb
sources/sakila/connection.yaml
```

Then:
```
filename: ./data/sakila.duckdb
```

Case B: If moved the file into /sources/sakila
```
sources/sakila/sakila.duckdb
sources/sakila/connection.yaml
```
Then:
```
filename: ./sources/sakila/sakila.duckdb
```
