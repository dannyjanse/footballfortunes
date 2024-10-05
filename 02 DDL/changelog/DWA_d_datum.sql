--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DWA_d_datum;
CREATE TABLE DWA_d_datum(
    datum Date
    ,jaar Integer
    ,maand Integer
    ,seizoen Varchar(10)
    ,winterstop Varchar (5)
    );