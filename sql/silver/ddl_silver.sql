/*
===============================================================================
DDL Script: Create Silver Football Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema for the SportsPipeline project,
    dropping existing tables if they already exist. These tables store **cleaned 
    and validated data** for competitions, teams, and matches, ready for analytical use.
===============================================================================
*/

-- ========================
-- Competitions Table
-- ========================

DROP TABLE IF EXISTS silver.competitions CASCADE;
CREATE TABLE silver.competitions(
    league_id INT PRIMARY KEY,                
    league_name VARCHAR(50) NOT NULL,         
    league_country VARCHAR(50),                
    league_logo VARCHAR(250),                 
    league_flag VARCHAR(250)                
);


-- ========================
-- Teams Table
-- ========================

DROP TABLE IF EXISTS silver.teams CASCADE;
CREATE TABLE silver.teams(
    team_id INT PRIMARY KEY,                     
    name VARCHAR(50),                               
    short_name VARCHAR(20),                        
    country VARCHAR(50),                       
    team_logo VARCHAR(250)                       
    );


-- ========================
-- Matches Table
-- ========================

DROP TABLE IF EXISTS silver.matches CASCADE;
CREATE TABLE silver.matches (
    match_id INT PRIMARY KEY,         
    competition_id INT,               
    season INT,               
    round VARCHAR(50) ,     
    date TIMESTAMP,             
    status VARCHAR(20),               
    home_team_id INT,      
    away_team_id INT,     
    winner VARCHAR(30),
    full_time_home INT,
    full_time_away INT,              
    half_time_home INT,              
    half_time_away INT              
);
