import functions as myf
import time

start_time = time.time()
print ('Transform & Load gestart')

# connectie maken met db
psy_connection = myf.connect_to_db()[0]
sqal_connection = myf.connect_to_db()[1]

####################################### TRANSFORM & LOAD ##################################
 

myf.sql_execute(psy_connection, 'd_datum.sql')
myf.sql_execute(psy_connection, 'd_wedstrijden.sql')

myf.sql_execute(psy_connection, 'f_bethistorie.sql')
myf.sql_execute(psy_connection, 'f_odds.sql')
myf.sql_execute(psy_connection, 'f_resultaten.sql')
myf.sql_execute(psy_connection, 'f_vorm.sql')

####################################### commit en sluit af #######################

myf.close_connection_db(psy_connection, sqal_connection)
end_time = time.time()

print(f'Transform & Load afgerond, duur: {round((end_time - start_time),1)} seconden')



