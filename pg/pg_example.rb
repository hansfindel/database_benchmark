# run: 
# 	CREATE DATABASE pg_example_db;
# before this script


require 'pg'
conn=PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db")
# select attnum, attname AS column, format_type(atttypid, atttypmod) AS type from pg_attribute;

conn.exec_params("DROP TABLE IF EXISTS films") # should skip this if doesn't exist
conn.exec_params("CREATE TABLE films (
    name  CHAR(20) NOT NULL,
    year INT )" );

conn.exec_params( 'INSERT INTO films (name, year) VALUES ($1, $2)', ['Matrix', 1999] )

conn.close