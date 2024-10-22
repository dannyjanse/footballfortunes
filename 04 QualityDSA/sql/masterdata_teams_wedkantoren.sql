-- check of er geen teams dubbel in d_teams staan behalve usual suspects
with 
	dubbele_teams as (
	select
	*, row_number() over (partition by team) as rownr
	from dwa_d_teams) ,
	dubbele_wedkantoren as (
	select
	*, row_number() over (partition by wedkantoor) as rownr
	from dwa_d_wedkantoren
	) 
-- check of er in masterdata teams dubbel zitten, behalve usual suspects
select
case when count(*) = 0 then 0 else 1 end 
,case when count(*) = 0 then 'geen dubbele waarden in dwa_d_teams, behalve usual suspects' else 'er zijn nieuwe dubbele waarden in dwa_d_teams, masterdata niet op orde' end
from dubbele_teams 
where rownr > 1 and team not in ('ajaccio', 'ajax', 'feirense', 'feyenoord', 'gaziantepspor', 'graafschap', 'groningen', 'heracles', 'mouscron', 'roda', 'utrecht', 'vitesse', 'willem ii', 'heidenheim', 'verona')
--
union
-- check of er in masterdata wedkantoren dubbelingen zitten
select 
case when count(*) = 0 then 0 else 1 end 
,case when count(*) = 0 then 'dwa_d_wedkantoren bevat geen dubbele waarden' else 'dwa_d_wedkantoren bevat dubbele waarden' end
from dubbele_wedkantoren where rownr > 1
;