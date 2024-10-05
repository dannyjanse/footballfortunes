def betgenerator(betparameters, psy_connection, sqal_connection):

    import pandas as pd
    import os
    
    print('betgenerator gestart')
    # psy_cursor = psy_connection.cursor()

    current_directory = os.getcwd()
    sql_file = f'{current_directory}\\Betgenerator\\sql\\betgenerator.sql'
    
    # Lees het SQL-bestand in en voer de queries uit
    with open(sql_file) as file:
        sql_script = file.read()
        odds = pd.read_sql(sql_script, sqal_connection)
    
    odds['fair_odd'] = None
    odds['min_odd'] = None
    odds['advies'] = None
    for comp in betparameters:
        for i, odd in odds.iterrows():
            if odd['competitie'] == comp[0]:
                fairodd = 1/(float(comp[1]) + float(comp[2]) * odd['gro'] + float(comp[5]) * odd['sro'])
                odds.at[i, 'fair_odd'] = fairodd
                min_odd  = round(fairodd + float(comp[8]), 2)
                odds.at[i, 'min_odd'] = min_odd
                if (odd['best_odd'] > min_odd and
                    odd['gro'] >= float(comp[3]) and odd['gro'] <= float(comp[4]) and
                    odd['sro'] >= float(comp[6]) and odd['sro'] <= float(comp[7]) and
                    odd['competitie'] in ('E0', 'D1', 'SP1', 'N1', 'T1')):
                    odds.at[i, 'advies'] = 1
                else: odds.at[i, 'advies'] = 0
    
    betadvies = odds[odds['advies'] == 1]
    #print(betadvies)
    print('betgenerator gereed')
    print(betadvies)
    return (betadvies)



       

