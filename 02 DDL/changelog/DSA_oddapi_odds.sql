--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DSA_oddapi_odds;
CREATE TABLE DSA_oddapi_odds(
    Div Varchar (100)
    ,Datum Varchar(100)
    ,Hometeam Varchar(100)
    ,Awayteam Varchar(100)
    ,Wedkantoor Varchar(100)
    ,h_odd_price Varchar(10)
    );