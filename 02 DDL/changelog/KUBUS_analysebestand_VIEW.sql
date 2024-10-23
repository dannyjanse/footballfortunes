--liquibase formatted sql

--changeset DJ:init
DROP VIEW IF EXISTS KUBUS_analysebestand;
create view KUBUS_analysebestand as
with odds as(
select 
hometeam, awayteam, odd_datum, max(odd_prijs) odd_prijs
from dwa_f_odds
group by 1,2,3
)
select dfr.*, vormh.GR_voor, vorma.GR_voor, (vormh.GR_voor - vorma.GR_voor) GRO
,odds.odd_prijs best_odd, bet.rea_odd, bet.rea_inzet, bet.wedkantoor 
from DWA_f_resultaten dfr 
left join odds
	on dfr.hometeam = odds.hometeam and dfr.awayteam = odds.awayteam and dfr.datum = odds.odd_datum
left join dwa_f_vorm vormh
	on dfr.hometeam = vormh.team and dfr.datum = vormh.datum
left join dwa_f_vorm vorma
	on dfr.awayteam = vorma.team and dfr.datum = vorma.datum
left join dwa_f_bethistorie bet 
	on dfr.hometeam = bet.hometeam and dfr.awayteam = bet.awayteam and dfr.datum = bet.datum
;