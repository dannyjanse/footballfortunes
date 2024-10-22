def backupdsa(psy_connection):
      
    print('backup DSA gestart')
    
    import csv
    from datetime import datetime
    
    huidige_datum = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    psy_cursor = psy_connection.cursor()
    
    backuptabellen = ['dsa_fd_stats', 'dsa_oddapi_odds', 'dsa_bets']

    for tabel in backuptabellen:
        # Step 2: Query the table (replace 'your_table_name' with your actual table name)
        psy_cursor.execute(f"SELECT * FROM {tabel}")

        # Fetch all the data from the table
        rows = psy_cursor.fetchall()

        # Step 3: Get the column names
        column_names = [description[0] for description in psy_cursor.description]

        # locatie voor backup
        output_file = f'C:/Users/JanseDanny/OneDrive/Documenten Danny/Football Fortunes/database/backup dsa/{huidige_datum}_backup_{tabel}.csv'

        # Step 4: Write the data to a CSV file
        with open(output_file, mode='w', newline='', encoding='utf-8') as file:
            csv_writer = csv.writer(file)

            # Write the column headers to the CSV file
            csv_writer.writerow(column_names)

            # Write the rows to the CSV file
            csv_writer.writerows(rows)
        
    psy_connection.commit()
    print(f'backup DSL gereed')

