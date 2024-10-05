with teamratios as (
	select team, gr, sr  
	from dwa_f_vorm_VIEW fv 
	where nr = 1 and seizoen = '2023/2024'
	)
select * from (
	select row_number() over (partition by dw.s_wedstrijd order by odd_prijs desc) as row_number, wedkantoor, dw.competitie, hometeam, tr1.gr as GRH
			, tr1.sr as SRH, awayteam, tr2.gr as GRA, tr2.sr as SRA 
			,tr1.gr - tr2.gr as gro, (tr1.sr-tr2.sr) as sro, odd_datum, od.odd_prijs as best_odd
			,dw.s_wedstrijd, dd.seizoen
	from dwa_f_odds od
	left outer join dwa_d_wedstrijden dw
		on od.s_wedstrijd = dw.s_wedstrijd 
	left outer join dwa_d_datum dd 
		on od.odd_datum = dd.datum
	left outer join teamratios tr1 
		on dw.hometeam = tr1.team
	left outer join teamratios tr2
		on dw.awayteam = tr2.team
		--)
	where odd_datum >= date('now') and odd_datum < date('now','+7 days')) actodds
where row_number = 1 AND competitie IS NOT null
order by competitie;