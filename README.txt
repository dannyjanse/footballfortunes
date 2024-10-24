START NIEUW SEIZOEN: 
- Controle op aantallen
	- Extract laatste resultaten van het oude seizoen
	- check de aantallen per competitie en onderzoek eventuele gekke resultaten
	- voeg een record toe aan CONTROLETABEL met aantallen van het oude seizoen
- Extract data nieuwe seizoen
	- PARAMETER AANPASSEN: haal data van het nieuwe seizoen op in 'Extract/fd_stats.py'
- Nieuwe teamnamen toevoegen aan dwa_d_teams
	- check voor dsa_fd_stats of er teams zijn die niet voorkomen in dwa_d_teams
	- idem voor dsa_oddapi_odds
	- voeg ontbrekende teams toe

TO DO: 
- DDL: rename DWA_f_bethistorie naar DWA_f_bets
- ETL pijplijn
	- inrichten QualityDWA proces met daarin
		- aantallencheck
		- dubbelencheck, wellicht hashes toevoegen en daarmee beter de sleutels definieren?
		- NULL checks
	- print een controle_tabel voor psv uit kubus, zodat je makkelijk ziet of data klopt
	- foutafhandeling in main.py en loglevel in console
	- temp tabellen vervangen door with tabellen
- Analysemodel verbeteren
- Airflow voor automatische ETL en monitoring
- Opensource BI tool toevoegen tbv analyse
- OO python tool voor ingest dsa_fd_stats
- Github actions voor backups en versiebeheer


