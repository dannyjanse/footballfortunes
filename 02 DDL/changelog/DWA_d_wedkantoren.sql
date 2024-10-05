--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DWA_d_wedstrijden;
CREATE TABLE DWA_d_wedstrijden(
    s_wedstrijd Integer
    ,competitie Varchar (10)
    ,hometeam Varchar(100)
    ,awayteam Varchar(100)
    );