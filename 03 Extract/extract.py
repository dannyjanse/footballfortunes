import functions as myf
import time

start_time = time.time()
print ('Proces gestart')

# geef aan welke functies te draaien
  # ETL_results draai je eenmalig na een speelronde
  # ETL_bets_historie draai je eenmalig nadat alle inzetten gedaan zijn voor een specifieke speelronde
  # ETL_bet_advies kun je meerdere keren draaien richting een speelronde om te kijken naar interessante odds
EXT_results = 'ja'
EXT_bet_historie = 'ja'
EXT_odds = 'ja'

######################################### CONNECTIE MAKEN ################################

# connectie maken met db
psy_connection = myf.connect_to_db()[0]
sqal_connection = myf.connect_to_db()[1]

####################################### ETL RESULTATEN ##################################

# geef aan welke competities in scope zijn en welk seizoen opgehaald moet worden
fd_stats_URL = 'https://www.football-data.co.uk/mmz4281'
competities = ['E0','E1','D1','I1','SP1','FR1','N1','B1','P1','T1','G1']
seizoen = 2324

if EXT_results == 'ja':
  
  # na iedere speelronde haal je resultaten op en verwerk je de gerealiseerde bets, eenmalig.
  # voor de hierboven opgegeven competities en seizoen worden alle resultaten van website football-data gehaald.
  # de resultaten worden vergeleken met de resultaten die reeds beschikbaar zijn in DSA.fd_stats. De delta wordt toegevoegd aan DSA
  # Er zit check op kolomnamen in de functie dus is proces robuust voor wijzigingen in kolomstructuur van football-data.
  myf.fd_stats(psy_connection, sqal_connection, fd_stats_URL, competities, seizoen)

######################################### ETL Betshistorie #########################################
  
if EXT_bet_historie == 'ja':
  
  # De tabel dsa_bets wordt geleegd.
  # Verolgens worden alle excelbestanden in bets_realisatie ingelezen in de DSA.
  myf.bets(psy_connection, sqal_connection)

########################################## ETL Betgenerator ############################################

if EXT_odds == 'ja':
  
  # geef aan welke competities in scope zijn en hoe ze relateren aan competities fd_stats
  URL = 'https://api.the-odds-api.com'
  apikey = '01f93cd4e8041d680add34efea99aff5'
  regions = 'eu'
  markets = 'h2h'
  competities = [['E0','soccer_epl'],['D1','soccer_germany_bundesliga'],['I1','soccer_italy_serie_a']
                ,['SP1','soccer_spain_la_liga'], ['FR1','soccer_france_ligue_one'],['N1','soccer_netherlands_eredivisie']
                ,['B1','soccer_belgium_first_div'] ,['P1','soccer_portugal_primeira_liga']
                ,['T1','soccer_turkey_super_league'],['G1','soccer_greece_super_league']]

  # DSA wordt geladen met nieuwe odds, of bestaande odds worden geupdate
  myf.oddapi_odds(psy_connection, sqal_connection, URL, apikey, regions, markets, competities)

########################################### CONNECTIE SLUITEN ##########################################

myf.close_connection_db(psy_connection, sqal_connection)
end_time = time.time()

print(f'Proces afgerond, duur: {round((end_time - start_time),1)} seconden')



