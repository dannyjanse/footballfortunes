def d_wedkantoor(psy_connection, sqal_connection):
 
    import pandas as pd
    print('transform & load d_wedkantoor gestart')
    psy_cursor = psy_connection.cursor()

    # Haal alle wedkantoren in oddapi op, én bestaande wedkantoren in d_wedkantoren
    wedkantoren_oddapi = pd.read_sql('SELECT distinct(wedkantoor) FROM dsa.oddapi_odds;', sqal_connection)
    bestaande_wedkantoren = pd.read_sql("SELECT * FROM dwa.d_wedkantoren ", sqal_connection)

    # WEDKANTOREN ODDAPI
    # Check of wedkantoren uit oddapi voorkomen in bestaande_wedkantoren
    # Zo niet dan voer je dit wedkantoor in
    # Invoer komt in lijst te staan
    wedkantoor_oddapi_lijst = []
    for i, wedkantoor_oddapi in wedkantoren_oddapi.iterrows():
        if wedkantoor_oddapi['wedkantoor'] not in bestaande_wedkantoren['wk_oddapi'].tolist():
            print ('nieuwe wedkantoren gevonden, voeg wedkantoorsleutel toe obv onderstaande lijst met reeds bekende wedkantoren')
            print(bestaande_wedkantoren)
            wedkantoor = wedkantoor_oddapi['wedkantoor']
            wedkantoorsleutel = input(f'wedkantoorsleutel voor wk_oddapi {wedkantoor}').lower()
            beschikbaar_nl = input(f'beschikbaar_nl True/False voor wk_oddapi {wedkantoor}')
            if beschikbaar_nl.lower() == 'true':
                beschikbaar_nl = bool('true')
            else:
                beschikbaar_nl = bool('')
            actief = input(f'actief True/False voor wk_oddapi {wedkantoor}')
            if actief.lower() == 'true':
                actief = bool('true')
            else:
                actief = bool('')
            wedkantoor_oddapi_lijst.append((wedkantoorsleutel, wedkantoor, beschikbaar_nl, actief))
    
    if not wedkantoor_oddapi_lijst: print('geen nieuwe wedkantoren gevonden')

    # Pak de lijst met nieuw ingevoerde wedkantoren voor oddapi
    # Als dit wedkantoor al voorkomt vanuit fd_stats dan UPDATE
    # Ander nieuw record toevoegen
    for i in wedkantoor_oddapi_lijst:
        if i[0] in bestaande_wedkantoren['wedkantoor'].tolist():
            psy_cursor.execute("""
                        UPDATE dwa.d_wedkantoren
                        SET wk_oddapi = %s, beschikbaar_nl = %s, actief = %s
                        WHERE wedkantoor = %s;                      
                        """,
                        (i[1], i[2], i[3], i[0]))
            psy_connection.commit()
        else: 
            psy_cursor.execute("""
                        INSERT INTO dwa.d_wedkantoren (wedkantoor, wk_fd, wk_oddapi, beschikbaar_nl, actief)
                        VALUES (%s, %s, %s, %s, %s);                        
                        """
                        ,(i[0], None, i[1], i[2], i[3]))
    
    sqal_connection.commit()
    psy_connection.commit()

    # update upate_tabel
    psy_cursor.execute("""
                            UPDATE dsa.update
                            SET update_datum = current_date
                            WHERE tabelnaam = 'd_wedkantoren';                      
                            """)
    psy_connection.commit()
        
    print('transform & load d_wedkantoor gereed')
            