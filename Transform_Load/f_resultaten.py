def f_resultaten(psy_connection):
      
    print('transform & load f_resultaten gestart')
    psy_cursor = psy_connection.cursor()

    # Haal alle wedstrijden op uit fd_stats_resultaten_VIEW, waarbij teamnamen geconformeerd en datum is DATE
    # JOIN met d_wedstrijden om wedstrijdsleutel op te halen
    # JOIN met f_resultaten om vast te stellen welke wedstrijden nog niet verwerkt zijn
    # INSERT betreffende wedstijden

    psy_cursor.execute("""
    INSERT INTO dwa_f_resultaten  
	SELECT
        r.s_wedstrijd			 
        ,r.datum				
        ,cast(case when r.fthg = 'NaN' then null else r.fthg end as Decimal)
        ,cast(case when r.ftag = 'NaN' then null else r.ftag end as Decimal)
        ,r.ftr
        ,cast(case when r.hthg = 'NaN' then null else r.hthg end as Decimal)
        ,cast(case when r.htag = 'NaN' then null else r.htag end as Decimal)
        ,r.htr            
        ,cast(case when r.hsh = 'NaN' then null else r.hsh end as Decimal)
        ,cast(case when r.ash = 'NaN' then null else r.ash end as Decimal)
        ,cast(case when r.hst = 'NaN' then null else r.hst end as Decimal)
        ,cast(case when r.ast = 'NaN' then null else r.ast end as Decimal)
        ,cast(case when r.hf = 'NaN' then null else r.hf end as Decimal)
        ,cast(case when r.af = 'NaN' then null else r.af end as Decimal)
        ,cast(case when r.hc = 'NaN' then null else r.hc end as Decimal)
        ,cast(case when r.ac = 'NaN' then null else r.ac end as Decimal)
        ,cast(case when r.hy = 'NaN' then null else r.hy end as Decimal)
        ,cast(case when r.ay = 'NaN' then null else r.ay end as Decimal)
        ,cast(case when r.hr = 'NaN' then null else r.hr end as Decimal)
        ,cast(case when r.ar = 'NaN' then null else r.ar end as Decimal)
    FROM (
        SELECT 
            dw.s_wedstrijd, datum
            ,fthg, ftag, ftr, hthg, htag, htr, hsh, ash
            ,hst, ast, hf, af, hc, ac, hy, ay, hr, ar
        FROM dsa_fd_stats_resultaten_view fdr
        LEFT JOIN dwa_d_wedstrijden dw 
            on (fdr.hometeam = dw.hometeam and fdr.awayteam = dw.awayteam)
        ORDER BY div, datum
        ) r
    LEFT JOIN dwa_f_resultaten fr 
        ON r.s_wedstrijd = fr.s_wedstrijd AND r.datum = fr.date
    WHERE fr.s_wedstrijd IS NULL
    ;            
    """)  

    psy_cursor.execute("""
    UPDATE dsa_update
    SET update_datum = date('now')
    WHERE tabelnaam = 'f_resultaten'
    ;                      
    """)  

    psy_connection.commit()
    print(f'transform & load f_resultaten gereed')
