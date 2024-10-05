--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DWA_f_bethistorie;
CREATE TABLE DWA_f_bethistorie(
speelronde integer
,datum date
,s_wedstrijd varchar (20)
,best_odd decimal
,min_odd decimal
,rea_inzet decimal
,rea_odd decimal
,wedkantoor varchar (50)
);