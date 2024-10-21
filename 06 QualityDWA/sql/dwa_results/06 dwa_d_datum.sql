-- check aantal dagen na current date groter is dan 25 (anders geef een 1)
select 
case when count < 25 then 1 else 0 end count
,case when count < 25 then 'er staan minder dan 25 data na de datum van vandaag in d_datum'
	else 'er staan meer dan 25 data na datum van vandaag in d_datum' end
from (
	select count(*) as count
	from dwa_d_datum dd 
	where datum > date('now')
	) telling;