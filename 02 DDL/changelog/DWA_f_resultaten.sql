--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DWA_f_resultaten;
CREATE TABLE DWA_f_resultaten(
    s_wedstrijd Integer
    ,date Date
    ,fthg Integer
    ,ftag Integer
    ,ftr Varchar(1)
    ,hthg Integer
    ,htag Integer
    ,htr Varchar(1)
    ,hsh Real
    ,ash Real
    ,hst Real
    ,ast Real
    ,hf Real
    ,af Real
    ,hc Real
    ,ac Real
    ,hy Real
    ,ay Real
    ,hr Real
    ,ar Real
    );