--liquibase formatted sql

--changeset DJ:init
DROP TABLE IF EXISTS DWA_d_teams;
CREATE TABLE DWA_d_teams(
    team Varchar (100)
    ,team_fd Varchar (100)
    ,team_oddapi Varchar (100)
    ,blessure Integer
    ,schorsingen Integer
    );