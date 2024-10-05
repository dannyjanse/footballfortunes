HOE DOCKER RUNNEN:

- in de functie db_connection.py moet je verwijzen naar sqlite database in de docker container de VOLUME
- in functie bets moet je verwijzen naar het excelbestand in bethistorie

DAARNA ONDERSTAANDE COMMANDO's RUNNEN

docker build -t extract .
docker run -v "C:/Users/JanseDanny/OneDrive/Documenten Danny/Football Fortunes:/app/data" -it extract