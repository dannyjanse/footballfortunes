--liquibase formatted sql

--changeset DJ:init-6
drop view if exists KUBUS_analysebestand;
create view KUBUS_analysebestand as
with odds as(
select 
hometeam, awayteam, odd_datum, max(odd_prijs) odd_prijs
from dwa_f_odds
group by 1,2,3
)
select 
ddw.competitie
,vormh.seizoen
,dfr.datum
,dfr.hometeam
,dfr.awayteam
,dfr.fthg, dfr.ftag ,dfr.ftr
,dfr.hsh ,dfr.ash
,dfr.hst ,dfr.ast
,dfr.hf ,dfr.af
,dfr.hc ,dfr.ac
,vormh.GR_voor GRH, vorma.GR_voor GRA, (vormh.GR_voor - vorma.GR_voor) GRO
,vormh.SR_voor SRH, vorma.SR_voor SRA, (vormh.SR_voor - vorma.SR_voor) SRO
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
LEFT JOIN DWA_d_wedstrijden ddw 
	ON dfr.s_wedstrijd = ddw.s_wedstrijd
;