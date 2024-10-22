delete from dwa_f_bethistorie;

INSERT INTO dwa_f_bethistorie (speelronde, datum, hometeam, awayteam, s_wedstrijd, best_odd, min_odd, rea_inzet, rea_odd, wedkantoor)
select 
bets.speelronde 
,date(((substr(bets.datum,0,5))||'-'||substr(bets.datum,6,2)||'-'||substr(bets.datum,9,2))) datum 
,bets.hometeam 
,bets.awayteam
,wedstrijd.s_wedstrijd 
,cast(replace(bets.best_odd, ',', '.') as numeric)
,CASE
    WHEN bets.min_odd = 'nan' THEN NULL
    ELSE CAST(replace(bets.min_odd, ',', '.') AS numeric(10,2))
    END 
,CASE
    WHEN bets.rea_inzet = 'nan' THEN NULL
    ELSE CAST(replace(bets.rea_inzet, ',', '.') AS numeric(10,2))
    END
,CAST(replace(bets.rea_odd, ',', '.') AS numeric(10,2))
,CASE
    WHEN bets.wedkantoor = 'nan' THEN NULL
    ELSE bets.wedkantoor
    END 
FROM DSA_bets bets
LEFT JOIN dwa_d_wedstrijden wedstrijd
	ON bets.hometeam = wedstrijd.hometeam AND bets.awayteam = wedstrijd.awayteam 
;