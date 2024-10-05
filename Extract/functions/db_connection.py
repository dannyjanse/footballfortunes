def connect_to_db():

    import sqlalchemy
    import sqlite3
    
    # Create SQL Alchemy database connection
    ##db_url = f"sqlite:///C:/Users/JanseDanny/OneDrive/Documenten Danny/Football Fortunes/database/DEV/footballfortunes.sqlite"
    db_url = f"sqlite:////app/data/database/DEV/footballfortunes.sqlite"
    engine = sqlalchemy.create_engine(db_url, echo=True)
    sqal_connection = engine.connect()

    # Create Psychop connection
    ##psy_connection = sqlite3.connect("C:/Users/JanseDanny/OneDrive/Documenten Danny/Football Fortunes/database/DEV/footballfortunes.sqlite")
    psy_connection = sqlite3.connect("/app/data/database/DEV/footballfortunes.sqlite")
    
    return psy_connection, sqal_connection

def close_connection_db(psy_connection, sqal_connection):
    
    # Commit de transactie en sluit de verbinding
    sqal_connection.close()
    psy_connection.close()   
    