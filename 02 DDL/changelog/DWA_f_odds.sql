--liquibase formatted sql

--changeset DJ:init-2
DROP TABLE IF EXISTS DWA_f_odds;
CREATE TABLE DWA_f_odds(
    s_wedstrijd Integer
    ,hometeam Varchar(100)
    ,awayteam Varchar(100)
    ,wedkantoor Varchar (100)
    ,odd_datum Date
    ,odd_type Varchar(10)
    ,odd_prijs Decimal
    );