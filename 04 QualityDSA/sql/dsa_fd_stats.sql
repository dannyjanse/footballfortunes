-- maak een tabel met volgnummers voor analyse van dubbele waarden in fd_stats
-- en een lijst met aantallen per seizoen in fd_stats voor vergelijk met controletabel
-- en een lijst met teamnamen in fd_stats voor vergelijk met dwa_d_teams
with 
	dubbele_fd_stats as (
		select
		row_number() over (partition by hometeam, awayteam, date) as rownr
		, div, date, hometeam, awayteam
		from dsa_fd_stats
	) ,
	aantallen_per_seizoen_fd_stats as (
		select 
		case when maand > 6 then jaar||(jaar+1) else (jaar-1)||jaar end seizoen
		,*
		from (
			select
			cast(substring(date, 4,2) as integer) maand
			,cast(substring(date, -2) as integer) jaar
			,*
			from dsa_fd_stats fs2) mndjr 
	) ,
	huidig_seizoen as (
	select 
	CASE WHEN maand > 6 THEN (CAST(jaar AS integer) - 2000)||(CAST(jaar AS integer) - 1999) --het jaartal minus 2000 en plus 1
        ELSE (CAST(jaar AS integer) - 2001)||(CAST(jaar AS integer) - 2000) END AS seizoen 
    from (select 
			strftime('%Y', 'now') jaar
			,strftime('%m', 'now') maand)
	),
	teamnamen_fd_stats as (
		select distinct team from (select hometeam as team from dsa_fd_stats union select awayteam as team from dsa_fd_stats))
-- check of er in dubbele waarden zitten in fd_stats obv unieke combi hometeam, awayteam en date
select 
aantal
,case when dubbele_check.aantal = 0 then 'dsa_fd_stats bevat geen dubbele waarden' else 'dsa_fd_stats bevat dubbele waarden' end
from(
	select count(*) as aantal from dubbele_fd_stats where rownr > 1
	) dubbele_check
---
union
--- check of de aantallen per seizoen overeenkomen met de controletabel die gemaakt en gecheckt is
select
case when sum = 0 then 0 else 1 end
,case when aantallen_check.sum = 0 then 'historische aantallen dsa_fd_stat correct' else 'historische aantallen dsa_fd_stat niet correct' end
from (
	select sum(aantal_controle - aantal_werkelijk) as sum
	from (
		select sz.div, sz.seizoen, min(wa.aantal) as aantal_controle, count(sz.seizoen) as aantal_werkelijk from aantallen_per_seizoen_fd_stats sz
		left outer join controle_wedstrijdaantallen wa
			on sz.div = wa.div and sz.seizoen = wa.seizoen
		where sz.seizoen <> (select * from huidig_seizoen)
		group by sz.seizoen, sz.div order by sz.div, sz.seizoen) vergelijk 
	) aantallen_check
---
union
--- check of de laatste wedstrijd in fd_stats niet ouder is dan 5 dagen
select 
case when (julianday(DATE('now')) - julianday(datum)) > 5 then 1 else 0 end
,case when (julianday(DATE('now')) - julianday(datum)) > 5 then 'laatste wedstrijd dsa_fd_stat meer dan 5 dagen oud, dus data niet actueel' else 'laatste wedstrijd dsa_fd_stat minder dan 5 dagen oud, dus data actueel' end
from (
		select 
		date((2000+substr(date,-2))||'-'||substr(date,4,2)||'-'||substr(date,1,2)) as datum 
		,* 
		from dsa_fd_stats fs2 order by datum desc limit 1
	) check_datum
---
union
--- check of er geen NULL waarden in fd_stats zitten obv de kolom 'date'
select 
case when count(*) = 0 then 0 else 1 end
,case when count(*) = 0 then 'dsa_fd_stats bevat geen wedstrijden met NULL waarden voor date' else 'dsa_fd_stats bevat wel wedstrijden met NULL waarden voor date' end
from dsa_fd_stats where date is null
---
union
--- check of alle teamnamen in fd_stats voorkomen in dwa_d_teams
select 
case when count(*) = 0 then 0 else 1 end
,case when count(*) = 0 then 'alle teamnamen in dsa_fd_stats zijn aanwezig in dwa_d_team' else 'niet alle teamnamen in dsa_fd_stats zijn aanwezig in dwa_d_team' end
from teamnamen_fd_stats where team not in (select team_fd from dwa_d_teams)
---
union
--- check of alle teamnamen in dwa_d_teams een sleutel hebben
select 
case when count(*) = 0 then 0 else 1 end
,case when count(*) = 0 then 'alle teamnamen in dwa_d_teams hebben een sleutel, masterdata op orde' else 'niet alle teamnamen in dwa_d_teams hebben een sleutel, masterdata niet op orde' end
from DWA_d_teams where (team_fd is not null and team is null) or (team_oddapi is not null and team is null)
;