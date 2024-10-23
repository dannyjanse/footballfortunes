def sql_execute(psy_connection, sql_bestand):

    import glob
    import os
    
    psy_cursor = psy_connection.cursor()

    print(f'Transform & Load {sql_bestand} gestart')
    
    # parent_directory = os.path.dirname(os.getcwd())
    path = f'{os.getcwd()}\\05 transform_load\\sql'
    sql_file_path = glob.glob(path + f'\\{sql_bestand}')
    print(path)
    print(sql_file_path)

    with open(sql_file_path[0], 'r') as sql_file:
        sql_script = sql_file.read()
        
    # Split the SQL file into individual commands
    commands = sql_script.split(';')

    # Execute each command
    for command in commands:
        if command.strip():  # Skip empty lines
            psy_cursor.execute(command)
    
    psy_connection.commit() 
       
    print(f'Transform & Load {sql_bestand} gereed')
    