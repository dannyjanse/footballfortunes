-- check dubbele waarden, moet 0 uitkomen
with 
	dubbele_oddapi as (
		select
		row_number() over (partition by hometeam, awayteam, wedkantoor, datum) as rownr
		,*
		from dsa_oddapi_odds
	) ,
	teamnamen_oddapi as (
		select distinct team from (select hometeam as team from dsa_oddapi_odds union select awayteam as team from dsa_oddapi_odds)
	),
	oddapi_data as (
		select 
		date(substring(datum, 1, 10)) datum
		from DSA_oddapi_odds doo 
	),
	wedkantoren_oddapi as (
		select distinct wedkantoor from dsa_oddapi_odds
	)
--- check of er dubbele waarden zijn in dsa_oddapi
select
case when count = 0 then 0 else 1 end
,case when count = 0 then 'dsa_oddapi_odds bevat geen dubbele records' else 'dsa_oddapi_odds bevat dubbele records' end 
from (select count(*) as count from dubbele_oddapi where rownr > 1) rijnummer
---
union
--- check of alle teamnamen voorkomen in dwa_d_team 
select 
case when count(*) = 0 then 0 else 1 end
,case when count(*) = 0 then 'alle teamnamen in dsa_oddapi zijn aanwezig in dwa_d_team en kunnen dus geconformeerd worden' else 'niet alle teamnamen in dsa_oddapi zijn aanwezig in dwa_d_team en dus gaat conformeren niet lukken' end
from teamnamen_oddapi where team not in (select team_oddapi from dwa_d_teams)
---
union
--- check of alle wedkantoren voorkomen in dwa_d_wedkantoor
select 
case when count(*) = 0 then 0 else 1 end
,case when count(*) = 0 then 'alle wedkantoren in dsa_oddapi zijn aanwezig in dwa_d_wedkantoren en kunnen dus geconformeerd worden' else 'niet alle wedkantoren in dsa_oddapi zijn aanwezig in dwa_d_wedkantoren en dus gaat conformeren niet lukken' end
from wedkantoren_oddapi where wedkantoor not in (select distinct wk_oddapi from dwa_d_wedkantoren)
---
union
--- check of dsa_oddapi_odds actuele data bevat
select
case when count(*) > 0 then 0 else 1 end
,case when count(*) > 0 then 'dsa_oddapi_odds bevat actuele odds' else 'dsa_oddapi_odds bevat geen actuele odds' end 
from oddapi_data 
where datum > date('now') 
---
union
--- check of alle teamnamen in dwa_d_teams een sleutel hebben
select 
case when count(*) = 0 then 0 else 1 end
,case when count(*) = 0 then 'alle wedkantoren in dwa_d_wedkantoren hebben een sleutel, masterdata op orde' else 'niet alle wedkantoren in dwa_d_wedkantoren hebben een sleutel, masterdata niet op orde' end
from DWA_d_wedkantoren where (wk_fd is not null and wedkantoor is null) or (wk_oddapi is not null and wedkantoor is null)
;
