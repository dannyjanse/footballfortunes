def quality_control(sqal_connection, controle_map):

    import pandas as pd
    import glob
    import os

    print(f'{controle_map} quality control gestart')
    
    parent_directory = os.path.dirname(os.getcwd())
    path = f'{os.getcwd()}/{controle_map}'
    sql_files = glob.glob(path + '/*.sql')
    print(path)
    print(sql_files)
    aantal_issues = 0

    for sql_file in sql_files:
        
    # Lees het SQL-bestand in en voer de queries uit
        with open(sql_file) as file:
            sql_script = file.read()
            resultaten = pd.read_sql(sql_script, sqal_connection)
                    
        for i, resultaat in resultaten.iterrows():
            if resultaat[0] == 0:
                print(f'   TOP! {resultaat[1]}')
            else: 
                print(f'   OEPS! {resultaat[1]}') 
                aantal_issues += 1
       
    print(f'{controle_map} quality control gereed')
    
    return(aantal_issues)