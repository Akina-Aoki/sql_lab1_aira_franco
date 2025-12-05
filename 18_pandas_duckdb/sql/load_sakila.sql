INSTALL sqlite;

LOAD sqlite;

CALL sqlite_attach('18_pandas_duckdb/data/sqlite-sakila.db'); -- had a problem with the path

/*
Change: 'data/sqlite-sakila.db' To: '18_pandas_duckdb/data/sqlite-sakila.db''
*/