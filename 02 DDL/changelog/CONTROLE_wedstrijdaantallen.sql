--liquibase formatted sql

--changeset DSA_fd_stats:init
DROP table IF EXISTS CONTROLE_wedstrijdaantallen;
CREATE table CONTROLE_wedstrijdaantallen (
div varchar (5)
,seizoen varchar (20)
,aantal int(4)
);