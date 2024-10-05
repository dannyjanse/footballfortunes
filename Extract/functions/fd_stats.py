def fd_stats(psy_connection, sqal_connection, URL, competities, seizoen):

        import requests
        import pandas as pd
        from io import StringIO      

        print('extract fd_stats gestart')
        # Bestaande gegevens ophalen (>2022, JAARLIJKS AANPASSEN) om nieuwe gegevens te kunnen bepalen
        # kolomnamen van db ophalen, om ze waar nodig toe te voegen aan de csv bestanden met nieuwe gegevens
        tel_aantal_nieuw = 0
        aantal_al_aanwezig = 0
        bestaande_gegevens = pd.read_sql("""SELECT * FROM DSA_fd_stats WHERE cast(substr(date,-2) as integer) >= strftime('%Y', current_timestamp) - 2001""", sqal_connection)
        kolomnamen_bestaand = [naam.lower() for naam in bestaande_gegevens.columns.tolist()]
        psy_cursor = psy_connection.cursor()
        
        # verwerken van nieuwe gegevens per competitie
        for comp in competities:
                response = requests.get(f'{URL}/{seizoen}/{comp}.csv')
                csv_data = StringIO(response.text)
                nieuwe_gegevens = pd.read_csv(csv_data)
                        
                # kolomnamen van de CSV bestanden naar lower case en HS en AS naar HSh en ASh, zodat het te matchen is met kolommen db
                nieuwe_gegevens.rename(columns={'HS':'hsh','AS':'ash'}, inplace=True)
                nieuwe_gegevens.columns = [naam.lower() for naam in nieuwe_gegevens.columns.tolist()]
                kolomnamen_nieuw = nieuwe_gegevens.columns
                
                # Als in db kolommen staan die ontbreken in CSV met nieuwe gegevens daar wordt deze kolom toegevoegd, zonder data
                # Dit is nodig om obv kolomnamen_bestaand de waarden op te halen in CSV met nieuwe gegevens, tbv INSERT
                for kolomnaam_bestaand in kolomnamen_bestaand: 
                        if kolomnaam_bestaand not in kolomnamen_nieuw: nieuwe_gegevens[kolomnaam_bestaand] = None
                
                # loop door alle regels binnen een CSV bestand met nieuwe gegevens heen en tel het aantal nieuwe INSERTS
                for i, nieuw_gegeven in nieuwe_gegevens.iterrows():
                        # maak voor iedere regel een lijst met alle waarden
                        nieuw_gegeven_values = []
                        for kolomnaam_bestaand in kolomnamen_bestaand:    
                                nieuw_gegeven_value = nieuw_gegeven[kolomnaam_bestaand]
                                nieuw_gegeven_values.append(nieuw_gegeven_value)
                        
                        # check of waarde al voorkomt in bestaande gegevens obv date en hometeam
                        date = nieuw_gegeven['date']
                        hometeam = nieuw_gegeven['hometeam']
                        if not bestaande_gegevens[(bestaande_gegevens['Date']==date) & (bestaande_gegevens['Hometeam']==hometeam)].empty:
                                aantal_al_aanwezig += 1
                        else:   
                                tel_aantal_nieuw += 1
                                psy_cursor.execute (
                                        """
                                        INSERT INTO DSA_fd_stats
                                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                                                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                                                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                                                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
                                                ?
                                                );
                                        """
                                , nieuw_gegeven_values
                                )
                                psy_cursor.execute (
                                        """
                                        DELETE from DSA_fd_stats WHERE date = 'NaN';
                                        """
                                )
        
        sqal_connection.commit()
        psy_connection.commit()              

        print(f'extract fd_stats aantal nieuwe wedstrijden: {tel_aantal_nieuw}') 
        print(f'extract fd_stats aantal al aanwezige wedstrijden: {aantal_al_aanwezig}') 
        print('extract fd_stats gereed')        

