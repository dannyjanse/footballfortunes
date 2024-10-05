--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DWA_f_odds;
CREATE TABLE DWA_f_odds(
    s_wedstrijd Integer
    ,wedkantoor Varchar (100)
    ,odd_datum Date
    ,odd_type Varchar(10)
    ,odd_prijs Decimal
    );