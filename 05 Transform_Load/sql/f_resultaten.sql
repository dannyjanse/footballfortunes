DELETE FROM dwa_f_resultaten;

drop table if exists unieke_teamnamen;
create temp table unieke_teamnamen as
select team_fd, max(team) as team
from DWA_d_teams ddt 
group by team_fd
;

drop table if exists resultaten;
CREATE TEMPORARY TABLE resultaten as
SELECT 
div,
date,
utn1.team AS hometeam,
utn2.team AS awayteam,
fthg,
ftag,
ftr,
hthg,
htag,
htr,
hsh,
ash,
hst,
ast,
hf,
af,
hc,
ac,
hy,
ay,
hr,
ar
FROM dsa_fd_stats fs2
    LEFT JOIN unieke_teamnamen utn1 ON fs2.hometeam = utn1.team_fd
    LEFT JOIN unieke_teamnamen utn2 ON fs2.awayteam = utn2.team_fd
;

INSERT INTO dwa_f_resultaten  
(s_wedstrijd, hometeam, awayteam, datum, fthg, ftag, ftr, hthg, htag, htr, hsh, ash, hst, ast, hf, af, hc, ac, hy, ay, hr, ar)
SELECT
dw.s_wedstrijd	
,r.hometeam
,r.awayteam
,date((substring(r.date, length(r.date)-1, 2)+2000)||'-'||substring(r.date, 4, 2)||'-'||substring(r.date, 1, 2))       datum		
,cast(case when r.fthg = 'NaN' then null else r.fthg end as Decimal)                                    fthg
,cast(case when r.ftag = 'NaN' then null else r.ftag end as Decimal)                                    ftag
,r.ftr                                                                                                  ftr
,cast(case when r.hthg = 'NaN' then null else r.hthg end as Decimal)                                    hthg
,cast(case when r.htag = 'NaN' then null else r.htag end as Decimal)                                    htag
,r.htr                                                                                                  htr        
,cast(case when r.hsh = 'NaN' then null else r.hsh end as Decimal)                                      hsh
,cast(case when r.ash = 'NaN' then null else r.ash end as Decimal)                                      ash
,cast(case when r.hst = 'NaN' then null else r.hst end as Decimal)                                      hst
,cast(case when r.ast = 'NaN' then null else r.ast end as Decimal)                                      ast
,cast(case when r.hf = 'NaN' then null else r.hf end as Decimal)	                                    hf
,cast(case when r.af = 'NaN' then null else r.af end as Decimal) 	                                    af
,cast(case when r.hc = 'NaN' then null else r.hc end as Decimal)                                        hc
,cast(case when r.ac = 'NaN' then null else r.ac end as Decimal)                                        ac
,cast(case when r.hy = 'NaN' then null else r.hy end as Decimal)                                        hy
,cast(case when r.ay = 'NaN' then null else r.ay end as Decimal)                                        ay
,cast(case when r.hr = 'NaN' then null else r.hr end as Decimal)                                        hr
,cast(case when r.ar = 'NaN' then null else r.ar end as Decimal)                                        ar
FROM resultaten r
LEFT JOIN dwa_d_wedstrijden dw 
    on (r.hometeam = dw.hometeam and r.awayteam = dw.awayteam and r.div = dw.competitie);
    ;  