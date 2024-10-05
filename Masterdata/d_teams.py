def d_teams(psy_connection, sqal_connection):

    import pandas as pd
    print('transform & load d_teams gestart')
    psy_cursor = psy_connection.cursor()

    ############################## FD_STATS AUTOMATISCH #################################################

    # Haal alle teams op in fd_stats, alsmede de teams die al bestaan in tabel teams
    teams_fd_stats = pd.read_sql("""SELECT distinct(hometeam) 
                                FROM DA_fd_stats
                                UNION
                                SELECT distinct(awayteam)
                                FROM DSA_fd_stats
                             ;""", sqal_connection)
    bestaande_teams = pd.read_sql('SELECT * FROM dwa.d_teams;', sqal_connection)

    # voeg alle teams in obv fd_stats als ze nog niet voorkomen
    # in de loop team_fd_stats ophalen, want er staan dubbele records in fd_stats
    aantal_nieuw = 0
    for i, team in teams_fd_stats.iterrows():
        if team['hometeam'] not in bestaande_teams['team_fd'].tolist():
            psy_cursor.execute("""
                            INSERT INTO dwa.d_teams
                            VALUES (%s, %s, NULL,  NULL, NULL);                        
                            """
                            ,(team['hometeam'].strip().lower(), team['hometeam']))  
            aantal_nieuw += 1 
    
    sqal_connection.commit()
    psy_connection.commit()
    print(f'het aantal nieuwe teams dat is gevonden en toegevoegd vanuit fd_stats: {aantal_nieuw}')

    ################################## ODDAPI AUTOMATISCH ########################################

    # Haal alle teams op in fd_stats en in oddapi, alsmede de teams die al bestaan in tabel teams
    teams_oddapi_odds = pd.read_sql("""SELECT distinct(hometeam) 
                                        FROM DSA_oddapi_odds
                                        UNION
                                        SELECT distinct(awayteam)
                                        FROM DSA_oddapi_odds
                                    ;""", sqal_connection)
    bestaande_teams = pd.read_sql('SELECT LOWER(team) as team, LOWER(team_oddapi) as team_oddapi FROM DWA_d_teams;', sqal_connection)

    # Check of teams uit oddapi_odds voorkomen in teams tabel, kolom odd_api
    # zo niet, check of naam overeenkomt met teamsleutel.
    # zo ja, automatisch invoeren (en UPDATEN)
    # zo nee, zie volgende stap
    aantal_automatisch_toegevoegd = 0
    teams_oddapi_lijst = []
    for i, team in teams_oddapi_odds.iterrows():
        teamnaam = team['hometeam']
        if teamnaam.lower() not in bestaande_teams['team_oddapi'].tolist():
            if teamnaam.lower() in bestaande_teams['team'].tolist():
                teams_oddapi_lijst.append((teamnaam))
                aantal_automatisch_toegevoegd += 1

    for i in teams_oddapi_lijst:
        psy_cursor.execute("""
                UPDATE DWA_d_teams
                SET team_oddapi = %s
                WHERE team = %s;                      
                """,
                (i, i.lower()))
    
    sqal_connection.commit()
    psy_connection.commit()
    print(f'het aantal nieuwe teams dat is gevonden en automatisch is teogevoegd vanuit odd_api: {aantal_automatisch_toegevoegd}')

    ############################### ODD_API HANDMATIG ###################################

    # Check of teams uit oddapi_odds voorkomen en zo niet voer ze in
    # invoer door eerste te checken of team te vinden is in sleutel
    # zo nee, handmatig invoeren
    teams_oddapi_lijst = []
    for i, team in teams_oddapi_odds.iterrows():
        teamnaam = team['hometeam']
        if teamnaam.lower() not in bestaande_teams['team_oddapi'].tolist():
            print('er is een nieuw team gevonden in odd_api waarvan naam niet overeenkomt met teamsleutel')
            print('zoek eerst de sleutel op in tabel d_teamnamen')
            zoek_op = input(f'voor {teamnaam} zoek op:')
            suggestie = bestaande_teams[bestaande_teams['team'].str.contains(zoek_op)]
            print(suggestie)
            if teamnaam.lower() not in bestaande_teams['team'].tolist():
                team_sleutel = input(f"voer de teamsleutel in voor dit nieuwe team in odd_api {teamnaam}").lower()
                psy_cursor.execute("""
                    UPDATE dwa.d_teams
                    SET team_oddapi = %s
                    WHERE team = %s;                      
                    """,
                    (teamnaam, team_sleutel))
                psy_connection.commit()
                break

    # update upate_tabel
    psy_cursor.execute("""
                            UPDATE dsa.update
                            SET update_datum = current_date
                            WHERE tabelnaam = 'd_teams';                      
                            """)
    
    sqal_connection.commit()
    psy_connection.commit()
    print('transform & load d_team gereed')

