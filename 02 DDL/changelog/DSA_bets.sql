--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DSA_bets;
CREATE TABLE DSA_bets(
speelronde varchar (10)
,seizoen varchar (20)
,competitie varchar (10)
,datum varchar (20)
,s_wedstrijd varchar (20)
,hometeam varchar (50)
,awayteam varchar (50)
,best_odd varchar (20)
,min_odd varchar (20)
,rea_inzet varchar (20)
,rea_odd varchar (20)
,wedkantoor varchar (50)
);