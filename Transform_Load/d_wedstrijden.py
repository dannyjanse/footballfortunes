def d_wedstrijden(psy_connection, sqal_connection):

    import pandas as pd
    print('transform & load d_wedstrijden gestart')
    psy_cursor = psy_connection.cursor()
    
    # Haal alle wedstrijden op uit fd_stats_resultaten_VIEW welke nog niet in dwa.d_wedstrijden staan
    aantal_nieuw_fd_stats = 0
    wedstrijden_fd_stats = pd.read_sql("""
                                        select 
                                                fsr.div
                                                ,fsr.hometeam
                                                ,fsr.awayteam
                                            from dsa_fd_stats_resultaten_VIEW fsr 
                                            left outer join dwa_d_wedstrijden dw 
                                                on fsr.hometeam = dw.hometeam and fsr.awayteam = dw.awayteam 
                                            where s_wedstrijd is null
                                            group by fsr.div, fsr.hometeam, fsr.awayteam;
                                        """, sqal_connection)

    for i, wedstrijd in wedstrijden_fd_stats.iterrows():
        psy_cursor.execute("""
                            INSERT INTO dwa_d_wedstrijden (competitie, hometeam, awayteam)
                            VALUES (?, ?, ?);                        
                            """
                            ,(wedstrijd[0], wedstrijd[1], wedstrijd[2]))  
        aantal_nieuw_fd_stats += 1 

    sqal_connection.commit()
    psy_connection.commit()
    print(f'het aantal nieuwe wedstrijden, toegevoegd vanuit fd_stats: {aantal_nieuw_fd_stats}')

    # Haal alle wedstrijden op uit oddapi_odds_VIEW welke nog niet in dwa.d_wedstrijden staan
    aantal_nieuw_oddapi_odds = 0
    wedstrijden_oddapi_odds = pd.read_sql("""
                                          select
                                                oo.div
                                                ,oo.hometeam
                                                ,oo.awayteam
                                            from dsa_oddapi_odds_VIEW oo 
                                            left outer join dwa_d_wedstrijden dw 
                                                on oo.hometeam = dw.hometeam and oo.awayteam = dw.awayteam 
                                            where s_wedstrijd is null
                                            group by oo.div, oo.hometeam, oo.awayteam;
                                        """, sqal_connection)

    for i, wedstrijd in wedstrijden_oddapi_odds.iterrows():
        psy_cursor.execute("""
                            INSERT INTO dwa_d_wedstrijden (competitie, hometeam, awayteam)
                            VALUES (?, ?, ?);                        
                            """
                            ,(wedstrijd[0], wedstrijd[1], wedstrijd[2]))  
        aantal_nieuw_oddapi_odds += 1 

    sqal_connection.commit()
    psy_connection.commit()
    print(f'het aantal nieuwe wedstrijden, toegevoegd vanuit odd_api: {aantal_nieuw_oddapi_odds}')

    # update upate_tabel
    psy_cursor.execute("""
                        UPDATE dsa_update
                        SET update_datum = date('now')
                        WHERE tabelnaam = 'd_wedstrijden';                      
                        """)
    
    psy_connection.commit()
    print('transform & load d_wedstrijden gereed')
