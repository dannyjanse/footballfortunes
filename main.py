import MyFunctions as myf
import Extract.functions as ext
import Masterdata as mstr
import Transform_Load as tl
import Control as ctrl
import Betgenerator as betgen
import time

start_time = time.time()
print ('Proces gestart')

# geef aan welke functies te draaien
  # ETL_results draai je eenmalig na een speelronde
  # ETL_bets_historie draai je eenmalig nadat alle inzetten gedaan zijn voor een specifieke speelronde
  # ETL_bet_advies kun je meerdere keren draaien richting een speelronde om te kijken naar interessante odds
  # Masterdata check je zo nu en dan. Niet heel veel reden om te denken dat daar iets mis zit als alle eerder kwaliteit checks OK zijn
ETL_results = 'nee'
ETL_bet_historie = 'nee'
ETL_bet_advies = 'ja'
Controle = 'nee'

######################################### CONNECTIE ################################

# connectie maken met db
psy_connection = myf.connect_to_db()[0]
sqal_connection = myf.connect_to_db()[1]

####################################### ETL RESULTATEN ##################################

# geef aan welke competities in scope zijn en welk seizoen opgehaald moet worden
fd_stats_URL = 'https://www.football-data.co.uk/mmz4281'
competities = ['E0','E1','D1','I1','SP1','FR1','N1','B1','P1','T1','G1']
seizoen = 2324

if ETL_results == 'ja':
  
  # na iedere speelronde haal je resultaten op en verwerk je de gerealiseerde bets, eenmalig.
  # voor de hierboven opgegeven competities en seizoen worden alle resultaten van website football-data gehaald.
  # de resultaten worden vergeleken de resultaten die reeds beschikbaar zijn in DSA.fd_stats. De delta wordt toegevoegd aan DSA
  # Er zit check op kolomnamen in de functie dus is proces robuust voor wijzigingen in kolomstructuur van football-data.
  # in de DSA staat een full load van alle resultaten --> dat is nodig voor dwa.odds
  ext.fd_stats(psy_connection, sqal_connection, fd_stats_URL, competities, seizoen)

  # als nieuwe resultaten zijn ingelezen in DSA en fd_stats_VIEW net geconformeerde teamnamen bevat zijn we klaar voor Transform & Load.
  # Eerst wordt tabel dwa.datum geupdate en worden eventuele nieuwe wedstrijden toegevoegd aan dwa.d_wedstrijden
  # De functie f_resultaten haalt dsa resultaten uit fd_stats_VIEW op, maakt JOIN met d_wedstrijden, vergelijkt met dwa.f_resultaten en voegt de delta toe.
  # Transform & load wordt afgesloten met kwaliteitscheck, welke voor f_resultaten nog niet is uitgewerkt
  tl.d_datum(psy_connection)
  tl.d_wedstrijden(psy_connection, sqal_connection)
  tl.f_resultaten(psy_connection)

############################################### ETL Betshistorie #########################################
  
if ETL_bet_historie == 'ja':
  
  # De tabel dsa.bets wordt geleegd.
  # Verolgens worden alle excelbestanden in bets_realisatie ingelezen in de DSA.
  ext.bets(psy_connection, sqal_connection)

  # In de dsa.bets_VIEW staat een subselectie van DSA.bets. 
  # Conformeren niet nodig omdat bron gebaseerd is betgenerator en dus al geconformeerd is. Wel worden data-types omgezet
  # In dsa.bets_VIEW staan dezelfde kolommen als in dwa.bethistorie. De delta tussen te tabellen wordt ingelezen voor dié odds waarvoor er ook een inzet is.
  tl.f_bethistorie(psy_connection)

############################################# ETL Betgenerator ############################################

if ETL_bet_advies == 'ja':
  
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
  #### ext.oddapi_odds(psy_connection, sqal_connection, URL, apikey, regions, markets, competities)

  # dwa.f_odds wordt getruncate
  # De odds uit dsa.fd_stats_odds_VIEW en dsa.oddapi_VIEW worden opgehaald uit de DSA en ingelezen in dwa.odds
  # Belangrijk dat dus niet een delta wordt ingelezen en we om die reden dus full loads nodig hebben in de DSA.
  tl.f_odds(psy_connection)
  
  # Op basis van de betparameters uit de predictive analysis wordt een betadvies gegenereerd
  # betparameters [(0)competitie, (1)a, (2)rc-GRO, (3)min-GRO, (4)max-GRO, (5)rc-SRO, (6)min-SRO, (7)max-SRO, (8)dif]
  betparameters = [
  ['E0', 0.65262, 0, -100, 100, 0.00747, -30, 25, 1.5],
  ['D1', 0.62924, 0, -100, 100, 0.00665, -35, 35, 1.5],
  ['I1', 0.50298, 0.01993, -1, 8, 0, -100, 100, 0.7],
  ['SP1', 0.65399, 0, -100, 100, 0.00603, -24, 28, 2],
  ['N1', 0.49805, 0.01847, -9, 6, 0, -100, 100, 1.3],
  ['B1', 0.48713, 0.01614, -10, 4, 0, -100, 100, 1.1],
  ['T1', 0.48870, 0.01590, -11, 7, 0, -100, 100, 0.2],
  ['G1', 0.53872, 0.02579, -8, 6, 0, -100, 100, 1]]
  # Let op, in betgerator sql zit een harde parameter 'seizoen'
  betadvies = betgen.betgenerator(betparameters, psy_connection, sqal_connection)

  # Het betadvies wordt in een excelbestand gezet in de map bet_advies. 
  # In het bestand staat een timestamp, dus het laatste bestand is altijd de meest actuele
  betgen.bet_excel(psy_connection, betadvies)

####################################### MASTERDATA ###############################

if Controle == 'ja':
  ctrl.quality_control(sqal_connection, 'dsa_fd_stats')
  ctrl.quality_control(sqal_connection, 'dwa_results')
  ctrl.quality_control(sqal_connection, 'dsa_odd_api')
  ##ctrl.quality_control(sqal_connection, 'dwa_bets')
  ctrl.quality_control(sqal_connection, 'masterdata')

# kwaliteitscontrole checkt of in de full load in de dsa voor alle competities in het verleden het aantal wedstrijden overeenkomt met controletabel+
# daarnaast wordt gecheckt of alle teamnamen in fd_stats_VIEW geconformeerd zijn. Dit is belangrijke basis voor load naar f_resultaten

# kwaliteitscontrole checkt of er geen dubbele waarden in dsa.odd_api zit en of waarden actueel zijn
# daarnaast wordt gecheckt of alle teamnamen én wedkantoren in odd_api_VIEW geconformeerd zijn. Dit is belangrijke basis voor load naar f_odds

# als dat onverhoopt niet zo is (meest logisch bij start nieuw seizoen) dan de functie voor het checken en aanvullen van masterdata starten
  ##mstr.d_teams(psy_connection, sqal_connection)
  ##mstr.d_wedkantoor(psy_connection, sqal_connection)
  ##mstr.d_teams(psy_connection, sqal_connection)

####################################### commit en sluit af #######################

myf.close_connection_db(psy_connection, sqal_connection)
end_time = time.time()

print(f'Proces afgerond, duur: {round((end_time - start_time),1)} seconden')



