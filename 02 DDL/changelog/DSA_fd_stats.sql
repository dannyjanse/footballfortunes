--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DSA_fd_stats;
CREATE TABLE DSA_fd_stats(
    DIV Varchar(4)
    ,Date Varchar (10)
    ,Hometeam Varchar(100)
    ,Awayteam Varchar(100)
    ,FTHG Varchar(10)
    ,FTAG Varchar(10)
    ,FTR Varchar(10)
    ,HTHG Varchar(10)
    ,HTAG Varchar(10)
    ,HTR Varchar(10)
    ,HSh Varchar (10)
    ,ASh Varchar (10)
    ,HST Varchar (10)
    ,AST Varchar (10)
    ,HF Varchar (10)
    ,AF Varchar (10)
    ,HC Varchar (10)
    ,AC Varchar (10)
    ,HY Varchar (10)
    ,AY Varchar (10)
    ,HR Varchar (10)
    ,AR Varchar (10)
    ,B365H Varchar(8)
    ,B365D Varchar(8)
    ,B365A Varchar(8)
    ,BSH Varchar(8)
    ,BSD Varchar(8)
    ,BSA Varchar(8)
    ,BWH Varchar(8)
    ,BWD Varchar(8)
    ,BWA Varchar(8)
    ,GBH Varchar(8)
    ,GBD Varchar(8)
    ,GBA Varchar(8)
    ,IWH Varchar(8)
    ,IWD Varchar(8)
    ,IWA Varchar(8)
    ,LBH Varchar(8)
    ,LBD Varchar(8)
    ,LBA Varchar(8)
    ,PSH Varchar(8)
    ,PSD Varchar(8)
    ,PSA Varchar(8)
    ,SOH Varchar(8)
    ,SOD Varchar(8)
    ,SOA Varchar(8)
    ,SBH Varchar(8)
    ,SBD Varchar(8)
    ,SBA Varchar(8)
    ,SJH Varchar(8)
    ,SJD Varchar(8)
    ,SJA Varchar(8)
    ,SYH Varchar(8)
    ,SYD Varchar(8)
    ,SYA Varchar(8)
    ,VCH Varchar(8)
    ,VCD Varchar(8)
    ,VCA Varchar(8)
    ,WHH Varchar(8)
    ,WHD Varchar(8)
    ,WHA Varchar(8)
    );