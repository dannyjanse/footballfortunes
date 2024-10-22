delete from dwa_f_odds;

CREATE TEMPORARY TABLE all_odds AS
SELECT 
sel.div,
sel.datum,
sel.hometeam,
sel.awayteam,
sel.wedkantoor,
sel.h_odd_price
FROM ( SELECT 
   		row_number() OVER (PARTITION BY dt.team, dt2.team, wk.wedkantoor, oo.datum, oo.h_odd_price) AS rownr
    	   ,oo.div
       	,date(((substr(oo.datum,0,5))||'-'||substr(oo.datum,6,2)||'-'||substr(oo.datum,9,2))) datum
        ,dt.team AS hometeam
        ,dt2.team AS awayteam
        ,wk.wedkantoor
        ,CAST(replace(oo.h_odd_price, ',', '.') AS numeric(10,2)) h_odd_price
        FROM dsa_oddapi_odds oo
        LEFT JOIN dwa_d_teams dt ON oo.hometeam = dt.team_oddapi
        LEFT JOIN dwa_d_teams dt2 ON oo.awayteam = dt2.team_oddapi
        LEFT JOIN dwa_d_wedkantoren wk ON oo.wedkantoor = wk.wk_oddapi
        ) sel
WHERE sel.rownr = 1
---
UNION
--- dsa_fd_stats_odds_view source
SELECT 
odds.div,
odds.datum,
dt.team AS hometeam,
dt2.team AS awayteam,
wk.wedkantoor,
odds.h_odd_price
FROM ( SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'B365' AS wedkantoor
        ,CAST(replace(fd_stats.b365h, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'BS' AS wedkantoor
        ,CAST(replace(fd_stats.bsh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'BW' AS wedkantoor
        ,CAST(replace(fd_stats.bwh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'GB' AS wedkantoor
        ,CAST(replace(fd_stats.gbh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'IW' AS wedkantoor
        ,CAST(replace(fd_stats.iwh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'IW' AS wedkantoor
        ,CAST(replace(fd_stats.iwh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'PS' AS wedkantoor
        ,CAST(replace(fd_stats.psh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'SO' AS wedkantoor
        ,CAST(replace(fd_stats.soh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'SB' AS wedkantoor
        ,CAST(replace(fd_stats.sbh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'SJ' AS wedkantoor
        ,CAST(replace(fd_stats.sjh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'SY' AS wedkantoor
        ,CAST(replace(fd_stats.syh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'VC' AS wedkantoor
        ,CAST(replace(fd_stats.vch, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats
       UNION
       SELECT 
 		fd_stats.div
 		,date((substring(fd_stats.date, 7, 2)+2000)||'-'||substring(fd_stats.date, 4, 2)||'-'||substring(fd_stats.date, 1, 2)) datum
        ,fd_stats.hometeam
        ,fd_stats.awayteam
        ,'WH' AS wedkantoor
        ,CAST(replace(fd_stats.whh, ',', '.') AS numeric(10,2)) h_odd_price
       FROM dsa_fd_stats fd_stats) odds
  LEFT JOIN dwa_d_teams dt ON odds.hometeam = dt.team_fd
  LEFT JOIN dwa_d_teams dt2 ON odds.awayteam = dt2.team_fd
  LEFT JOIN dwa_d_wedkantoren wk ON odds.wedkantoor = wk.wk_fd
  WHERE h_odd_price IS NOT NULL
;

INSERT INTO dwa_f_odds 
SELECT
dw.s_wedstrijd
,all_odds.hometeam
,all_odds.awayteam
,all_odds.wedkantoor
,all_odds.datum
,'H'
,all_odds.h_odd_price
FROM all_odds
LEFT JOIN dwa_d_wedstrijden dw 
   ON all_odds.hometeam = dw.hometeam AND all_odds.awayteam = dw.awayteam
;  