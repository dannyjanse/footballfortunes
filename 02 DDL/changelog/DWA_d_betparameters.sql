--liquibase formatted sql

--changeset DJ:init-3
DROP TABLE IF EXISTS DWA_d_betparameters;
CREATE TABLE DWA_d_betparameters(
    competitie Varchar(100)
    ,a Decimal
    ,rc_GRO Decimal
    ,min_GRO Integer
    ,max_GRO Integer
    ,rc_SRO Integer
    ,min_SRO Integer
    ,max_SRO Integer
    ,dif Decimal
    );