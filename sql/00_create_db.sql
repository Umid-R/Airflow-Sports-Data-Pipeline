/*
=============================================================
Create Database and Schemas (PostgreSQL)
=============================================================
Script Purpose:
    This script creates a new database named 'SportsPipeline'. 
    Additionally, it sets up three schemas within the database: 
    'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the 'SportsPipeline' database 
    if it already exists. All data will be permanently deleted.
*/

-- Drop database if it exists
DROP DATABASE IF EXISTS SportsPipeline;

-- Create the database
CREATE DATABASE SportsPipeline;

-- After creating the database, connect to it:
-- In psql:  \c SportsPipeline
-- In TablePlus/pgAdmin: select 'SportsPipeline' from the database list

-- Create Schemas (run these inside the SportsPipeline database)
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

