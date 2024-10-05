--- check of alle teamnamen in oddapi_view en fd_stats_view geconformeerd zijn
select 
count
,case when count = 0 then 'alle teamnamen in fd_stats_view zijn geconformeerd, masterdata op orde' 
	else 'niet alle teamnamen in fd_stats zijn geconformeerd, masterdata niet op orde' end
from (
	select count(*) as count from DSA_fd_stats_resultaten_view where hometeam is null
	UNION
	select count(*) as count from DSA_fd_stats_resultaten_view where awayteam is null
	) teamnamen;