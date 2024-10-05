--liquibase formatted sql

--changeset DJ:init
DROP VIEW IF EXISTS KUBUS_betresultaten_VIEW;
create view KUBUS_betresultaten_VIEW as 
select 
bh.speelronde,
dw.competitie,
dd.seizoen,
bh.datum,
dw.hometeam,
dw.awayteam,
fr.fthg,
fr.ftag,
fr.ftr,
bh.best_odd,
bh.min_odd,
bh.rea_inzet,
bh.rea_odd,
case when fr.ftr = 'H' then 1 else 0 end wins
from DWA_f_bethistorie bh
left outer join DWA_d_wedstrijden dw 
	on bh.s_wedstrijd = dw.s_wedstrijd
left outer join DWA_d_datum dd 
	on bh.datum = dd.datum
left outer join DWA_f_resultaten fr 
	on bh.datum = fr.date and bh.s_wedstrijd = fr.s_wedstrijd
;