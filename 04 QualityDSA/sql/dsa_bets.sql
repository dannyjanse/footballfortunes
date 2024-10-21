WITH teamnamen AS (
SELECT DISTINCT teamnaam FROM (SELECT hometeam AS teamnaam FROM dsa_bets UNION SELECT awayteam AS teamnaam FROM dsa_bets)
)
-- test of alle teamnamen voorkomen in dwa_d_teams
SELECT 
CASE WHEN count(*) = 0 THEN 0 ELSE 1 END
,CASE WHEN count(*) = 0 THEN 'alle teamnamen in dsa_bets komen voor in dwa_d_team' ELSE 'niet alle teamnamen in dsa_bets komen voor in dwa_d_team' end
FROM teamnamen WHERE teamnaam not IN (SELECT team FROM DWA_d_teams)
--
UNION
--
SELECT
CASE WHEN count(*) = 0 THEN 0 ELSE 1 END
,CASE WHEN count(*) = 0 THEN 'alle records hebben een gerealiseerde inzet' ELSE 'er zijn records waarvoor óf rea_inzet óf rea_odd een "nan" waarde heeft' end
FROM dsa_bets WHERE rea_inzet = 'nan' OR rea_odd = 'nan'
;