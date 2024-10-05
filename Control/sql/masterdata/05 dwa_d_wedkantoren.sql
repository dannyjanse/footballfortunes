with rownr as (
	select
	row_number() over (partition by wedkantoor) as rownr
	,*
	from dwa.d_wedkantoren
	) 
select 
count
,case when count = 0 then 'd_wedkantoren bevat geen dubbele waarden' else 'd_wedkantoren bevat dubbele waarden' end
from (
	select count(*) from rownr where rownr > 1 
	) dubbelen
