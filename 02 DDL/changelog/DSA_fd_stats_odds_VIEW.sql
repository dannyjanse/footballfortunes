--liquibase formatted sql

--changeset DSA_fd_stats:init
DROP VIEW DSA_fd_stats_odds_VIEW;
CREATE VIEW DSA_fd_stats_odds_VIEW AS
select 
odds.div
,odds.datum
,dt.team as hometeam
,dt2.team as awayteam
,wk.wedkantoor as wedkantoor
,h_odd_price
from (
	select 
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'B365' wedkantoor
	,b365h as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'BS' wedkantoor
	,bsh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'BW' wedkantoor
	,bwh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'GB' wedkantoor
	,gbh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'IW' wedkantoor
	,iwh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'LB' wedkantoor
	,lbh as h_odd_price
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'PS' wedkantoor
	,psh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'SO' wedkantoor
	,soh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'SB' wedkantoor
	,sbh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'SJ' wedkantoor
	,sjh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'SY' wedkantoor
	,syh as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'VC' wedkantoor
	,vch as h_odd_price 
	from DSA_fd_stats
	union
	select
	div
	,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	,hometeam 
	,awayteam
	,'WH' wedkantoor
	,whh as h_odd_price 
	from DSA_fd_stats 
	) odds
left outer join DWA_d_teams dt 
	on odds.hometeam = dt.team_fd  
left outer join DWA_d_teams dt2 
	on odds.awayteam = dt2.team_fd
left outer join DWA_d_wedkantoren wk
	on odds.wedkantoor = wk.wk_fd 
order by div, datum
;