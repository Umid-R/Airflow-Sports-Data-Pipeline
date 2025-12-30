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
    cmt_id INT PRIMARY KEY, 
    name VARCHAR(50),            
    code VARCHAR(10),               
    type VARCHAR(50),                 
    emblem VARCHAR(250)            
);

-- ========================
-- Teams Table
-- ========================

DROP TABLE IF EXISTS bronze.teams CASCADE;
CREATE TABLE bronze.teams (
    team_id INT PRIMARY KEY,  
    name VARCHAR(50),     
    short_name VARCHAR(20),  
    tla VARCHAR(10),     
    crest VARCHAR(250),            
    competition_id INT            
);

-- ========================
-- Matches Table
-- ========================

DROP TABLE IF EXISTS bronze.matches CASCADE;
CREATE TABLE bronze.matches (
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
    half_time_home INT,              
    half_time_away INT              
);
