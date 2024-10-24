--- deze visuele check ergens in het proces printen

select * from KUBUS_analysebestand ka 
WHERE (hometeam = 'psv eindhoven' OR awayteam = 'psv eindhoven') AND datum > date('now', '-100 day')
ORDER BY datum desc;