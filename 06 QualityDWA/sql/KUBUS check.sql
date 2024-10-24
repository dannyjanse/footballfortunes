select 
hometeam, awayteam, datum
,fthg, ftag, fthg-ftag, GRH, GRA, GRO 
,hsh, ash, hsh-ash, SRH, SRA, SRO
from kubus_analysebestand
where hometeam = 'psv eindhoven' or awayteam = 'psv eindhoven'
order by datum desc;

select count(*) from KUBUS_analysebestand ka