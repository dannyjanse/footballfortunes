def oddapi_odds(psy_connection, sqal_connection, URL, apikey, regions, markets, competities):
    
    import requests
    import pandas as pd
    
    print('extract oddapi_odds gestart')
    # proces variabelen
    bestaande_gegevens = pd.read_sql("""SELECT * FROM dsa_oddapi_odds WHERE date(datum) >= date('now')""", sqal_connection)
    psy_cursor = psy_connection.cursor()

    for competitie in competities:
        tel_nieuwe_odd = 0
        tel_update_odd = 0
        GET = f'/v4/sports/{competitie[1]}/odds/?apiKey={apikey}&regions={regions}&markets={markets}'

        # haal alle odds per bookamer op
        wedstrijden = requests.get(f"{URL}{GET}").json()
        for wedstrijd in wedstrijden:
            bookmakers = wedstrijd['bookmakers']
            
            for bookmaker in bookmakers:
                wedkantoor = (bookmaker['key'])
                if wedstrijd['home_team'] == bookmaker['markets'][0]['outcomes'][0]['name']:
                    h_odd_price = bookmaker['markets'][0]['outcomes'][0]['price']
                else: 
                    h_odd_price = bookmaker['markets'][0]['outcomes'][1]['price']
                h_odd = [wedstrijd['commence_time'],wedstrijd['home_team'],wedstrijd['away_team'], wedkantoor, h_odd_price] 
                
                # Update odd indien wedstrijd al voorkomt, anders nieuwe odd toevoegen aan db
                nieuw_wel_niet = True
                for index, bestaand_gegeven in bestaande_gegevens.iterrows():
                    if h_odd[0] == bestaand_gegeven[1] and h_odd[1] == bestaand_gegeven[2] and h_odd[3] == bestaand_gegeven[4]:
                        nieuw_wel_niet = False
                        if str(h_odd[4]) != str(bestaand_gegeven[5]):
                            tel_update_odd += 1
                            psy_cursor.execute("""
                                                UPDATE dsa_oddapi_odds 
                                                SET h_odd_price = ?
                                                WHERE datum = ? and hometeam = ? and wedkantoor = ?;"""
                                                ,(h_odd[4], h_odd[0], h_odd[1], h_odd[3]))
                  
                if nieuw_wel_niet == True: 
                    tel_nieuwe_odd += 1
                    psy_cursor.execute("""
                                        INSERT INTO dsa_oddapi_odds (div, datum, hometeam ,awayteam, wedkantoor, h_odd_price)
                                        VALUES (?, ?, ?, ?, ?, ?);"""
                                        ,(competitie[0], h_odd[0], h_odd[1], h_odd[2], h_odd[3], h_odd[4]))
        
        print(f'extract oddapi_odds aantal nieuwe odds in {competitie[0]}: {tel_nieuwe_odd}')
        print(f'extract oddapi_odds aantal updates in {competitie[0]}: {tel_update_odd}')

    sqal_connection.commit()
    psy_connection.commit() 
    print('extract oddapi_odds gereed')
