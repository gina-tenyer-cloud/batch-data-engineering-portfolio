# 🚕 Batch Data Engineering Portfolio – NYC Taxi Pipeline

Dieses Repository enthält eine reproduzierbare, Docker-basierte Batch-Datenpipeline für NYC-Taxi-Daten. Das Projekt demonstriert den Aufbau einer modernen Datenarchitektur mit klarer Trennung von Orchestrierung, Verarbeitung und Speicherung nach dem Bronze–Silver–Gold-Prinzip.

## Architektur (Überblick)

Das System besteht aus folgenden Microservices:

- Airflow (Webserver + Scheduler): Orchestrierung der Datenpipeline  
- Apache Spark (Master + Worker): Datenverarbeitung und Transformation  
- MinIO (S3-kompatibler Object Storage): Speicherung der Roh- und verarbeiteten Daten  
- PostgreSQL: Metadaten-Backend für Airflow  
- Docker Compose: Lokales Deployment aller Services  

Alle Komponenten laufen lokal als Container und kommunizieren über ein gemeinsames Docker-Netzwerk.

## Datenpipeline (Bronze → Silver → Gold)

### Bronze (Raw → Parquet)
- Einlesen der NYC-Taxi-CSV-Datei mit Spark  
- Speicherung als Parquet-Dateien für effizientere Weiterverarbeitung  

### Silver (Cleaned Data)
- Datentypbereinigung (z. B. Timestamps, numerische Werte)  
- Entfernen leerer oder ungültiger Werte  
- Strukturierte Speicherung als Parquet  

### Gold (Aggregierte Business-Metriken)
- Aggregation nach Datum  
- Berechnung der täglichen Gesamteinnahmen (total_fare)  
- Speicherung als analysierbare Parquet-Tabelle  

Die gesamte Verarbeitung befindet sich in:
services/processing/jobs/process_taxi_data.py

## Wie starte ich das Projekt?

1. Voraussetzungen  
- Docker Desktop installiert und gestartet  
- Git installiert  

2. Repository klonen  
git clone https://github.com/gina-tenyer-cloud/batch-data-engineering-portfolio.git  
cd batch-data-engineering-portfolio  

3. Alle Services starten  
docker compose up -d  

4. Wichtige Web-Interfaces  
- Airflow: http://localhost:8088 (admin / admin)  
- MinIO Console: http://localhost:9001 (minioadmin / minioadmin123)  
- Spark Master UI: http://localhost:8080  

## Spark-Job manuell ausführen (optional)
docker exec -it batch-data-engineering-portfolio-spark-master-1 \
  /opt/spark/bin/spark-submit /opt/spark_jobs/jobs/process_taxi_data.py

## Reproduzierbarkeit

Dieses Projekt ist vollständig reproduzierbar:
- Alle Abhängigkeiten laufen in Containern  
- Keine Cloud-Ressourcen erforderlich  
- Funktioniert auf jedem Rechner mit Docker  

## Mögliche Erweiterungen
- Streaming-Pipeline mit Spark Structured Streaming  
- Inkrementelle Verarbeitung statt reiner Batch-Verarbeitung  
- Speicherung in Delta Lake oder Iceberg  
- Erweiterte Data-Quality-Checks  


