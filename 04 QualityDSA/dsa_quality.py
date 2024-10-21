import functions as myf
import time

start_time = time.time()
print ('Proces gestart')


# connectie maken met db
psy_connection = myf.connect_to_db()[0]
sqal_connection = myf.connect_to_db()[1]


# kwaliteitcontrole dsa
aantal_issues = myf.quality_control(sqal_connection, 'sql')
print(f'HET TOTAAL AANTAL ISSUES UIT DE KWALITEITCONTROLE DSA IS: {aantal_issues}')


####################################### commit en sluit af #######################

myf.close_connection_db(psy_connection, sqal_connection)
end_time = time.time()

print(f'Proces afgerond, duur: {round((end_time - start_time),1)} seconden')



