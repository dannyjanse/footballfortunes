delete from dwa_d_wedstrijden;

INSERT INTO dwa_d_wedstrijden (competitie, hometeam, awayteam) 
SELECT distinct div, hometeam, awayteam 
FROM (
	SELECT div, teamh.team hometeam, teama.team awayteam 
	FROM DSA_fd_stats dfs 
	LEFT JOIN  dwa_d_teams teamh	
		ON dfs.hometeam = teamh.team_fd
	LEFT JOIN  dwa_d_teams teama
		ON dfs.awayteam = teama.team_fd
	---
	UNION
	---
	select div, teamh.team, teama.team 
	from DSA_oddapi_odds doo
	left join dwa_d_teams teamh
		on doo.hometeam = teamh.team_oddapi
	left join dwa_d_teams teama
		on doo.awayteam = teama.team_oddapi
	) totaal_odds
;