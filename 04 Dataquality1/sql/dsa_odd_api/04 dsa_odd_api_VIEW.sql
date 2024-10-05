--- check of alle teamnamen in oddapi_view geconformeerd zijn
select 
count
,case when count = 0 then 'alle teamnamen in oddapi_view zijn geconformeerd, masterdata op orde' 
	else 'niet alle teamnamen in oddapi_view zijn geconformeerd, masterdata niet op orde' end
from (
	select count(*) as count from dsa_oddapi_odds_view oov where hometeam is null
	UNION
	select count(*) as count from dsa_oddapi_odds_view oov where awayteam is null
	) teamnamen
UNION
select 
count
, case when count = 0 then 'alle wedkantoren in oddapi_odds_VIEW en/of fd_stats_odds_VIEW zijn geconformeerd, masterdata wedkantoren op orde' 
	else 'niet alle wedkantoren in oddapi_odds_VIEW en/of fd_stats_odds_VIEW zijn geconformeerd, masterdata wedkantoren niet op orde' end
from (
	select count(*) as count from dsa_oddapi_odds_view where wedkantoor is null
	UNION
	select count(*) as count from dsa_fd_stats_odds_view where wedkantoor is null
	) wedkantoren ;
	