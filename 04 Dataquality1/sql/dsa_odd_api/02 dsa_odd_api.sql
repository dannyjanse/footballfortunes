-- check dubbele waarden, moet 0 uitkomen
with rownr as (
	select
	row_number() over (partition by hometeam, awayteam, wedkantoor, datum) as rownr
	,*
	from dsa_oddapi_odds
	) 
select
count
,case when count = 0 then 'dsa_oddapi_odds bevat geen dubbele waarden' else 'dsa_oddapi_odds bevat dubbele waarden' end 
from (
	select count(*) as count from rownr where rownr > 1
	) rijnummer
UNION
-- zijn er actuele odds, moet in principe groter dan null zijn
-- uitvoeren op view, want in dsa.oddapi_odds is datum een een varchar
select
case when count > 0 then 0 else 1 end
,case when count > 0 then 'dsa_oddapi_odds bevat actuele odds' else 'dsa_oddapi_odds bevat geen actuele odds' end 
from (
	select count (*) as count from dsa_oddapi_odds_view oo 
	where datum - date('now') > 0 ) actueel
;