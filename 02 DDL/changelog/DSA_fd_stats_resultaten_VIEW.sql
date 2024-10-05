--liquibase formatted sql

--changeset DSA_fd_stats:init
DROP VIEW IF EXISTS DSA_fd_stats_resultaten_VIEW;
CREATE VIEW DSA_fd_stats_resultaten_VIEW AS
SELECT 
div
,datum
,hometeam
,awayteam
,fthg
,ftag
,ftr
,hthg 
,htag 
,htr 
,hsh 
,ash 
,hst 
,ast
,hf 
,af 
,hc
,ac 
,hy 
,ay 
,hr 
,ar 
FROM (SELECT  
	        row_number() over (partition by hometeam, awayteam, div, date) nr
			,date 
			,date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) datum
	        ,div
	        ,dt.team hometeam
	        ,dt2.team awayteam
	        ,fthg
	        ,ftag
	        ,ftr
	        ,hthg 
	        ,htag 
	        ,htr 
	        ,hsh 
	        ,ash 
	        ,hst 
	        ,ast
	        ,hf 
	        ,af 
	        ,hc
	        ,ac 
	        ,hy 
	        ,ay 
	        ,hr 
	        ,ar 
	FROM DSA_fd_stats fs2 
	LEFT OUTER JOIN DWA_d_teams dt 
		on hometeam = dt.team_fd 
	LEFT OUTER JOIN DWA_d_teams dt2 
		on awayteam = dt2.team_fd 
) bron
WHERE nr = 1
ORDER BY div, datum;