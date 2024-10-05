-- check of er geen teams dubbel in d_teams staan behalve usual suspects
with dubbel as (
	select
	row_number() over (partition by team) as rownr
	,*
	from dwa.d_teams) 
select
count
,case when count = 0 then 'geen dubbele waarden in d_teams, behalve usual suspects' else 'er zijn nieuwe dubbele waarden in d_teams, masterdata niet op orde' end
from (
	select 
	count(*) 
	from dubbel 
	where rownr > 1 and team not in ('ajaccio', 'ajax', 'feirense', 'feyenoord', 'gaziantepspor', 'graafschap', 'groningen', 'heracles', 'mouscron', 'roda', 'utrecht', 'vitesse', 'willem ii')
	) dubbelcheck
