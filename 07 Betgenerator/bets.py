import functions as myf
import time

start_time = time.time()
print ('Proces betgeneratie gestart')

# connectie maken met db
psy_connection = myf.connect_to_db()[0]
sqal_connection = myf.connect_to_db()[1]

myf.betgenerator(sqal_connection)

myf.close_connection_db(psy_connection, sqal_connection)
end_time = time.time()

print(f'Proces betgeneratie afgerond, duur: {round((end_time - start_time),1)} seconden')



