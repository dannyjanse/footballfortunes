def betgenerator(sqal_connection):

    from datetime import datetime
    import pandas as pd
    import glob
    import os
    
    print('betgenerator gestart')
    # psy_cursor = psy_connection.cursor()
    
    huidige_datum = datetime.now().strftime("%Y%m%d_%I%M%S")
    
    # Lees het SQL-bestand in en voer de queries uit
    sql_file = 'betgenerator.sql'
    path = f'{os.getcwd()}\\07 betgenerator\\sql'
    sql_file_path = glob.glob(path + f'\\{sql_file}')
    print(path)
    print(sql_file_path)
    
    with open(sql_file_path[0]) as file:
        sql_script = file.read()
        betadvies = pd.read_sql(sql_script, sqal_connection)
    
    print(betadvies)
    betadvies.to_excel(f'C:\\Users\\JanseDanny\\OneDrive\\Documenten Danny\\Football Fortunes\\Bet_advies\\betadvies_{huidige_datum}.xlsx', index=False, engine='openpyxl')



       

