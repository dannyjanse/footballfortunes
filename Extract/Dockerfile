# Stap 1: Gebruik de officiële Python 3.11.5 Slim image als basis
FROM python:3.11.5-slim

# Stap 2: Stel de werkdirectory in binnen de container
WORKDIR /app

# Stap 3: Kopieer het requirements-bestand (voor Python dependencies) naar de container
COPY requirements.txt .

# Stap 4: Installeer de Python dependencies
RUN pip install -r requirements.txt

# Stap 5: Kopieer de rest van de applicatiecode naar de container
COPY . .

# Stap 6: Stel de SQLite database in als volume (optioneel als je data persistent wilt maken)
VOLUME ["app/db"]

# Stap 8: Specificeer het commando om de Python-applicatie te starten
CMD ["python", "extract.py"]
