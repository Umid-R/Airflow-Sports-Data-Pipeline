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
    competition_id INT PRIMARY KEY,                
    competition_name VARCHAR(50) NOT NULL,         
    competition_code VARCHAR(10),                
    competition_type VARCHAR(50),                 
    competition_emblem VARCHAR(250)                
);


-- ========================
-- Teams Table
-- ========================

DROP TABLE IF EXISTS silver.teams CASCADE;
CREATE TABLE silver.teams(
    team_id INT PRIMARY KEY,                     
    name VARCHAR(50),                               
    short_name VARCHAR(20),                        
    team_abbr VARCHAR(10),                       
    team_logo VARCHAR(250),                       
    competition_id INT                             
);


-- ========================
-- Matches Table
-- ========================

DROP TABLE IF EXISTS silver.matches CASCADE;
CREATE TABLE silver.matches(
    match_id INT PRIMARY KEY,                       
    competition_id INT,                            
    season_id INT,                                  
    matchday INT,                                
    stage VARCHAR(50),                      
    utc_date TIMESTAMP,                            
    status VARCHAR(20),                       
    home_team_id INT,                                
    away_team_id INT,                               
    winner VARCHAR(20),                            
    full_time_home INT,
    full_time_away INT ,                            
    half_time_home INT,                            
    half_time_away INT                               
);
