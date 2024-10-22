--liquibase formatted sql

--changeset DJ:init-3
DROP TABLE IF EXISTS DWA_f_resultaten;
CREATE TABLE DWA_f_resultaten(
    s_wedstrijd Integer
    ,hometeam Varchar(100)
    ,awayteam Varchar(100)
    ,datum Date
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