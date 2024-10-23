WITH odds AS (
SELECT hometeam, awayteam, odd_datum, max(odd_prijs) best_odd
FROM dwa_f_odds
GROUP BY 1,2,3
HAVING odd_datum > current_date
),
actuele_vorm AS (
SELECT * FROM dwa_f_vorm
WHERE nr = 1
),
advies_berekening AS ( 
select
dt.seizoen
,o.odd_datum
,ddw.competitie
,ddw.hometeam 
,ddw.awayteam 
,o.best_odd
,vhome.GR_na GR_home
,vaway.GR_na GR_away
,(vhome.GR_na - vaway.GR_na) GRO
,(vhome.SR_na - vaway.SR_na) SRO
,ddb.a
,ddb.rc_GRO 
,ddb.rc_GRO
,ddb.min_GRO
,ddb.max_GRO
,ddb.min_SRO
,ddb.max_SRO
,ddb.dif
,1/(ddb.a + ddb.rc_GRO * (vhome.GR_na - vaway.GR_na)  + ddb.rc_SRO * (vhome.SR_na - vaway.SR_na)) + dif min_odd
FROM odds o
LEFT JOIN DWA_d_wedstrijden ddw 
	ON o.hometeam = ddw.hometeam AND o.awayteam = ddw.awayteam 
LEFT JOIN DWA_d_betparameters ddb 
	ON ddw.competitie = ddb.competitie
LEFT JOIN dwa_d_datum dt 
	ON o.odd_datum = dt.datum
LEFT JOIN actuele_vorm vhome
	ON ddw.hometeam = vhome.team
LEFT JOIN actuele_vorm vaway 
	ON ddw.awayteam = vaway.team
WHERE 
ddw.competitie IN ('E0', 'D1', 'SP1', 'N1', 'T1')
)
SELECT 
'' speelronde
,seizoen
,competitie
,odd_datum
,hometeam 
,awayteam 
,best_odd
,min_odd
,'' rea_inzet
,'' rea_odd
,'' wedkantoor
FROM advies_berekening
WHERE best_odd > min_odd
AND GRO > min_GRO and GRO < max_GRO and SRO > min_SRO and SRO < max_SRO 