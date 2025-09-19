# Preparation du lab

Dans cet atelier, nous utiliserons le registre de schémas de Confluent ( Schema Registry ) pour assurer la validité des schémas des messages que nous allons générer, dont les valeurs seront formatées en format Avro. Vous utiliserez également un connecteur source MQTT dans Kafka Connect pour importer des données depuis une source de données IoT.

## Pré-requis
Exécutez le cluster Kafka en accédant au dossier du projet et en exécutant le script start.sh :

    cd ~/confluent-lab/labs/ecosystem
    ./start.sh

Cela démarrera notre mini cluster Kafka, créera le sujet « véhicules-positions », puis démarrera le producteur qui écrit les données de notre source IoT vers le sujet.
