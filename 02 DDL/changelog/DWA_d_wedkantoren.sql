--liquibase formatted sql

--changeset DJ:init2
DROP TABLE IF EXISTS DWA_d_wedkantoren;
CREATE TABLE DWA_d_wedkantoren(
    wedkantoor Varchar (100)
    ,wk_fd Varchar (100)
    ,wk_oddapi Varchar (100)
    ,beschikbaar_NL Boolean
    ,actief Boolean
    );