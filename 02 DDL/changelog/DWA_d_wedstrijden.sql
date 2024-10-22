--liquibase formatted sql

--changeset DJ:init-2
DROP TABLE IF EXISTS DWA_d_wedstrijden;
CREATE TABLE DWA_d_wedstrijden(
    s_wedstrijd INTEGER PRIMARY KEY AUTOINCREMENT
    ,competitie Varchar (10)
    ,hometeam Varchar(100)
    ,awayteam Varchar(100)
    );