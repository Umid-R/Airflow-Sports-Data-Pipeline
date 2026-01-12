/*
===============================================================================
DDL Script: Create Bronze Football Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema for the SportsPipeline project,
    dropping existing tables if they already exist. These tables store raw API data
    for competitions, teams, and matches.
===============================================================================
*/

-- ========================
-- Competitions Table
-- ========================

DROP TABLE IF EXISTS bronze.competitions CASCADE;
CREATE TABLE bronze.competitions (
    id INT PRIMARY KEY, 
    name VARCHAR(50),            
    country VARCHAR(100),               
    logo VARCHAR(100),                 
    flag VARCHAR(100)            
);

-- ========================
-- Teams Table
-- ========================

DROP TABLE IF EXISTS bronze.teams CASCADE;
CREATE TABLE bronze.teams (
    team_id INT PRIMARY KEY,  
    name VARCHAR(50),     
    short_name VARCHAR(20),  
    country VARCHAR(50),     
    logo VARCHAR(250)           
               
);

-- ========================
-- Matches Table
-- ========================

DROP TABLE IF EXISTS bronze.matches CASCADE;
CREATE TABLE bronze.matches (
    match_id INT PRIMARY KEY,         
    competition_id INT,               
    season INT,               
    round VARCHAR(50) ,     
    date TIMESTAMP,             
    status VARCHAR(20),               
    home_team_id INT,      
    away_team_id INT,     
    winner_home VARCHAR(20), 
    winner_away VARCHAR(20),           
    full_time_home INT,
    full_time_away INT,              
    half_time_home INT,              
    half_time_away INT              
);



-- ========================
-- Dates
-- ========================

DROP TABLE IF EXISTS bronze.dates CASCADE;
CREATE TABLE bronze.dates (
    date_id serial PRIMARY KEY,
    date DATE  
);
