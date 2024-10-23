delete from dwa_d_wedstrijden;

drop table if exists unieke_teamnamen_fd_stats;
create temp table unieke_teamnamen_fd_stats as
select team_fd, max(team) as team
from DWA_d_teams ddt 
group by team_fd
;

drop table if exists unieke_teamnamen_oddapi;
create temp table unieke_teamnamen_oddapi as
select team_oddapi, max(team) as team
from DWA_d_teams ddt 
group by team_fd
;

INSERT INTO dwa_d_wedstrijden (competitie, hometeam, awayteam) 
SELECT distinct div, hometeam, awayteam 
FROM (
	SELECT div, teamh.team hometeam, teama.team awayteam 
	FROM DSA_fd_stats dfs 
	LEFT JOIN  unieke_teamnamen_fd_stats teamh	
		ON dfs.hometeam = teamh.team_fd
	LEFT JOIN  unieke_teamnamen_fd_stats teama
		ON dfs.awayteam = teama.team_fd
	---
	UNION
	---
	select div, teamh.team, teama.team 
	from DSA_oddapi_odds doo
	left join unieke_teamnamen_oddapi teamh
		on doo.hometeam = teamh.team_oddapi
	left join unieke_teamnamen_oddapi teama
		on doo.awayteam = teama.team_oddapi
	) totaal_odds
;
