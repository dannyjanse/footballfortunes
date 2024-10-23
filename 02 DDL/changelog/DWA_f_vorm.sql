--liquibase formatted sql

--changeset DJ:init-4
DROP TABLE IF EXISTS DWA_f_vorm;
CREATE TABLE DWA_f_vorm(
    nr Integer
	,team Varchar(100)
	,GRW Integer
	,SRW Integer
	,seizoen Varchar(100)
    ,hometeam Varchar(100)
    ,awayteam Varchar(100)
	,s_wedstrijd Integer
    ,datum Date
    ,fthg Integer
    ,ftag Integer
    ,hsh Real
    ,ash Real
	,GR_na Integer
	,SR_na Integer
    ,GR_voor Integer
	,SR_voor Integer
    );