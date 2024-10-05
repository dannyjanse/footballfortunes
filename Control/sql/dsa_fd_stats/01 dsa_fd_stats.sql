-- maak een lijst met volgnummers voor dubbele waarden
-- en een lijst met seizoenen
with 
	dubbele as (
		select
		row_number() over (partition by hometeam, awayteam, date) as rownr
		, div, date, hometeam, awayteam
		from dsa_fd_stats
	) ,
	metseizoen as (
		select 
		case when maand > 6 then jaar||(jaar+1) else (jaar-1)||jaar end seizoen
		,*
		from (
			select
			cast(substring(date, 4,2) as integer) maand
			,cast(substring(date, -2) as integer) jaar
			,*
			from dsa_fd_stats fs2) mndjr 
	) 
-- kijk of er volgnummers zijn groter dan 1
select 
aantal
,case when dubbele_check.aantal = 0 then 'dsa_fd_stats bevat geen dubbele waarden' else 'dsa_fd_stats bevat dubbele waarden' end
from(
	select count(*) as aantal from dubbele where rownr > 1
	) dubbele_check
---
union
--- check of de aantallen per seizoen overeenkomen met de controletabel die gemaakt en gecheckt is
select
sum
,case when aantallen_check.sum = 0 then 'historische aantallen dsa_fd_stat correct' else 'historische aantallen dsa_fd_stat niet correct' end
from (
	select sum(count2 - count) as sum
	from (
		select sz.div, sz.seizoen, count(sz.seizoen) as count, wa.aantal as count2 from metseizoen sz
		left outer join controle_wedstrijdaantallen wa
			on sz.div = wa.div and sz.seizoen = wa.seizoen
		where sz.seizoen <> '2324'
		group by sz.seizoen, sz.div order by sz.div, sz.seizoen) vergelijk 
	) aantallen_check
---
union
----
select 
case when (julianday(DATE('now')) - julianday(datum)) > 5 then 1 else 0 end
,case when (julianday(DATE('now')) - julianday(datum)) > 5 then 'laatste wedstrijd dsa_fd_stat meer dan 5 dagen oud, dus data niet actueel' 
	else 'laatste wedstrijd dsa_fd_stat minder dan 5 dagen oud, dus data actueel' end
from (
	select 
	date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) as datum 
	,* 
	from dsa_fd_stats fs2 order by datum desc limit 1
) check_datum;




