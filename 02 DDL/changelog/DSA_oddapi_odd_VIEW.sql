--liquibase formatted sql

--changeset DSA_fd_stats:init
DROP VIEW DSA_oddapi_odds_VIEW;
CREATE VIEW DSA_oddapi_odds_VIEW AS
SELECT
div
,datum
,hometeam
,awayteam
,wedkantoor
,h_odd_price
FROM (
	SELECT 
	row_number() over (partition by dt.team, dt2.team, wk.wedkantoor, datum) as rownr
	,oo.div div
	,date(oo.datum) datum
	,dt.team as hometeam
	,dt2.team as awayteam
	,wk.wedkantoor as wedkantoor
	,oo.h_odd_price
	FROM DSA_oddapi_odds oo 
	LEFT OUTER JOIN DWA_d_teams dt 
		on hometeam = dt.team_oddapi  
	LEFT OUTER JOIN DWA_d_teams dt2 
		on awayteam = dt2.team_oddapi 
	LEFT OUTER JOIN DWA_d_wedkantoren wk
		on oo.wedkantoor = wk.wk_oddapi
	ORDER BY div, datum) sel
WHERE rownr > 1
;