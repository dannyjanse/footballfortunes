def f_bethistorie(psy_connection):

    print('transform & load f_bethistorie gestart')
    psy_cursor = psy_connection.cursor()
    
    # haal alle bets op uit met een ingevulde rea_inzet uit dsa.bets_VIEW
    # voeg de bets die nog niet zijn opgenomen in dwa.bets_historie op
    
    psy_cursor.execute("""
    WITH nieuwe_odds AS (
	SELECT bv.* 
	FROM dsa_bets_view bv
	LEFT OUTER JOIN dwa_f_bethistorie fb 
	ON bv.datum = fb.datum AND bv.s_wedstrijd = fb.s_wedstrijd
	WHERE fb.datum IS NULL AND fb.s_wedstrijd IS NULL AND bv.rea_inzet IS NOT NULL
	)
    INSERT INTO dwa_f_bethistorie
    SELECT * FROM nieuwe_odds;                    
    """)
    
    psy_connection.commit()
    print('transform & load f_bethistorie gereed')
