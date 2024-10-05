-- controleer of geen enkele wedstrijdsleutel er dubbel in staat
with rownr as (
	select
	row_number() over (partition by s_wedstrijd) as rownr
	,*
	from dwa_d_wedstrijden
	) 
select
count
,case when count = 0 then 'd_wedstrijden bevat geen dubbele records' else 'd_wedstrijden bevat dubbele records' end 
from (
	select count(*) as count from rownr where rownr > 1 
	) telling
union
-- check of er null waarden voorkomen bij hometeam en awayteam
select 
count
,case when count = 0 then 'd_wedstrijden bevat geen NULL waarden voor home- en/of awayteam'
	else 'd_wedstrijden bevat NULL waarden voor home- en/of awayteam' end
from (
	select count(*) as count from dwa_d_wedstrijden where awayteam is null
	union
	select count(*) as count from dwa_d_wedstrijden where hometeam is null
	) telling2;
