-- DWA_f_vorm_VIEW source

CREATE VIEW DWA_f_vorm_VIEW AS
WITH wedstrijden AS (
	SELECT dd.seizoen, hometeam, awayteam, fr.s_wedstrijd, date, fthg, ftag, hsh, ash
	from DWA_f_resultaten fr
	LEFT OUTER JOIN DWA_d_wedstrijden dw 
		ON fr.s_wedstrijd = dw.s_wedstrijd
	left outer join DWA_d_datum dd 
		on fr.date = dd.datum 
    )
SELECT 
row_number() over (partition BY team, seizoen order by date desc) nr
,*
,LAG(GRW, 0) OVER (partition BY team, seizoen order by date) +
 LAG(GRW, 1) OVER (partition BY team, seizoen order by date) +
 LAG(GRW, 2) OVER (partition BY team, seizoen order by date) +
 LAG(GRW, 3) OVER (partition BY team, seizoen order by date) AS GR -- Goalratio
,LAG(SRW, 0) OVER (partition BY team, seizoen order by date) +
 LAG(SRW, 1) OVER (partition BY team, seizoen order by date) +
 LAG(SRW, 2) OVER (partition BY team, seizoen order by date) +
 LAG(SRW, 3) OVER (partition BY team, seizoen order by date) AS SR -- Shotratio
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
		ORDER BY team, date
		) GR;