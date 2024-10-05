def f_odds(psy_connection):

    print('transform & load f_odds gestart')
    psy_cursor = psy_connection.cursor()
    
    # haal alle odds op oddapi_odds en de fd_stats_odds_view en UNION de tabellen voor totaallijst
    # haal wedstrijdsleutel op in d_wedstrijden
    # JOIN met f_odds om te kijken welke waarden nog niet in f_odds staan
    # voeg betreffende waarden toe
    
    psy_cursor.execute("""
    DELETE FROM dwa_f_odds ;                       
    """)

    psy_cursor.execute("""
    INSERT INTO dwa_f_odds 
    SELECT
    odd_conf.s_wedstrijd
    ,odd_conf.wedkantoor
    ,odd_conf.datum
    ,odd_conf.odd_type
    ,cast(odd_conf.h_odd_price as decimal)
    FROM (
        SELECT 
        s_wedstrijd
        ,wedkantoor
        ,datum 
        ,'homeodd' as odd_type
        ,h_odd_price 
        FROM (
            SELECT * FROM dsa_fd_stats_odds_view fsov
            UNION
            SELECT * FROM dsa_oddapi_odds_view oov 
            ORDER BY div, datum
            ) all_odds
        LEFT OUTER JOIN dwa_d_wedstrijden dw 
            ON all_odds.hometeam = dw.hometeam AND all_odds.awayteam = dw.awayteam
        ) odd_conf;                         
    """)

    psy_cursor.execute("""
    UPDATE dsa_update
    SET update_datum = date('now')
    WHERE tabelnaam = 'f_odds';                      
    """)
    
    psy_connection.commit()
    print('transform & load f_odds gereed')
