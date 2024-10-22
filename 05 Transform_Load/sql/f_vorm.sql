delete from dwa_f_vorm;

CREATE TEMPORARY TABLE vorm AS
WITH wedstrijden AS (
	SELECT dd.seizoen, dw.hometeam, dw.awayteam, dw.s_wedstrijd, fr.datum, fthg, ftag, hsh, ash
	from DWA_f_resultaten fr
	LEFT OUTER JOIN DWA_d_wedstrijden dw 
		ON fr.s_wedstrijd = dw.s_wedstrijd
	left outer join DWA_d_datum dd 
		on fr.datum = dd.datum 
    )
SELECT 
row_number() over (partition BY team, seizoen order by datum desc) nr
,*
,LAG(GRW, 0) OVER (partition BY team, seizoen order by datum) +
 LAG(GRW, 1) OVER (partition BY team, seizoen order by datum) +
 LAG(GRW, 2) OVER (partition BY team, seizoen order by datum) +
 LAG(GRW, 3) OVER (partition BY team, seizoen order by datum) AS GR -- Goalratio
,LAG(SRW, 0) OVER (partition BY team, seizoen order by datum) +
 LAG(SRW, 1) OVER (partition BY team, seizoen order by datum) +
 LAG(SRW, 2) OVER (partition BY team, seizoen order by datum) +
 LAG(SRW, 3) OVER (partition BY team, seizoen order by datum) AS SR -- Shotratio
 FROM (
		SELECT 
		hometeam AS team
		,fthg - ftag AS GRW -- GoalRatio Wedstrijd
		,hsh - ash as SRW	-- ShotRatio Wedstrijd
		,* 
		FROM wedstrijden
		UNION
		SELECT awayteam AS team
		,-1*(fthg - ftag) AS GRW -- GoalRatio Wedstrijd
		,-1*(hsh - ash) as SRW	-- ShotRatio Wedstrijd
		,* 
		FROM wedstrijden
		ORDER BY team, datum
		) GR;
		
insert into dwa_f_vorm (nr, team, GRW, SRW, seizoen, hometeam, awayteam, s_wedstrijd, datum, fthg, ftag, hsh, ash, GR, SR)
select * from vorm;