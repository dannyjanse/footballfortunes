def bets(psy_connection, sqal_connection):

    import pandas as pd
    import glob

    print('extract bethistorie gestart')
    psy_cursor = psy_connection.cursor()

    ##path = f'C:\\Users\\JanseDanny\\OneDrive\\Documenten Danny\\Football Fortunes\\Bet_realisatie'
    path = f'app\\data\\Bet_realisatie'
    excel_files = glob.glob(path + '/*.xlsx')

    ##psy_cursor.execute("""Delete from dsa_bets;""")
    ##aantal_nieuw = 0
    for excel_file in excel_files:
        df = pd.read_excel(excel_file)
        for i, wedstrijd in df.iterrows():
                psy_cursor.execute("""
                        INSERT INTO dsa_bets (
                        speelronde, 
                        seizoen,
                        competitie,
                        datum,
                        s_wedstrijd,
                        hometeam,
                        awayteam,
                        best_odd,
                        min_odd,
                        rea_inzet,
                        rea_odd,
                        wedkantoor)                      
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);                        
                        """
                        ,(str(wedstrijd[0]), str(wedstrijd[1]), str(wedstrijd[2]), str(wedstrijd[3]), str(wedstrijd [4]), str(wedstrijd[5]),
                          str(wedstrijd[6]), str(wedstrijd[7]), str(wedstrijd[8]), str(wedstrijd[9]), str(wedstrijd[10]), str(wedstrijd[11])))  
                ##aantal_nieuw += 1 
    psy_cursor.execute("""CREATE TEMP TABLE DSA_bets_tmp 
                          AS
                          SELECT 
                          *
                          ,ROW_NUMBER() OVER(PARTITION BY datum, hometeam, awayteam ) as row_num
                          FROM dsa_bets
                          ;""")
    psy_cursor.execute("""DELETE FROM dsa_bets;""")
    psy_cursor.execute("""INSERT INTO DSA_bets 
                          SELECT 
                          speelronde  
                          ,seizoen 
                          ,competitie 
                          ,datum 
                          ,s_wedstrijd 
                          ,hometeam 
                          ,awayteam 
                          ,best_odd 
                          ,min_odd 
                          ,rea_inzet 
                          ,rea_odd 
                          ,wedkantoor
                          FROM dsa_bets_tmp
                          WHERE row_num = 1
                          ;""")
    psy_connection.commit()
    ##print(f'aantal gerealiseerde bets toegevoegd aan dsa_bets: {aantal_nieuw}')
    print('extract bethistorie gereed')
   