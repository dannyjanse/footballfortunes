def bet_excel (psy_connection, betadvies):

    import pandas as pd
    import os
    from datetime import datetime

    huidige_datum = datetime.now().strftime('%Y%m%d_%H%M%S')
    current_directory = os.getcwd()

    betadvies['speelronde'] = None
    betadvies['rea_inzet'] = None
    betadvies['rea_odd'] = None
    betadvies['wedkantoor'] = None
    betadvies_excel = betadvies[['speelronde','seizoen','competitie','odd_datum','s_wedstrijd','hometeam','awayteam',
                                 'best_odd','min_odd','rea_inzet','rea_odd','wedkantoor']]
    
    print(betadvies_excel)

    betadvies_excel.to_excel(f'C:\\Users\\JanseDanny\\OneDrive\\Documenten Danny\\Football Fortunes\\Bet_advies\\test\\betadvies_{huidige_datum}.xlsx', index=False, engine='openpyxl')