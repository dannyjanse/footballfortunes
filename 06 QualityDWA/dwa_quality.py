import functions as myf
import time

start_time = time.time()
print ('Proces gestart')


# connectie maken met db
psy_connection = myf.connect_to_db()[0]
sqal_connection = myf.connect_to_db()[1]


# kwaliteitcontrole dwa

#### CHECK ALLE SLEUTELS
#### check consistentie seizoenen en competitie namen

myf.quality_control(sqal_connection, 'dwa_results')
myf.quality_control(sqal_connection, 'dwa_bets')

####################################### commit en sluit af #######################

myf.close_connection_db(psy_connection, sqal_connection)
end_time = time.time()

print(f'Proces afgerond, duur: {round((end_time - start_time),1)} seconden')



