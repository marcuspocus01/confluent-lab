# Preparation du lab

Dans cet atelier, nous utiliserons le registre de schémas de Confluent ( Schema Registry ) pour assurer la validité des schémas des messages que nous allons générer, dont les valeurs seront formatées en format Avro. Vous utiliserez également un connecteur source MQTT dans Kafka Connect pour importer des données depuis une source de données IoT.

## Pré-requis
Exécutez le cluster Kafka en accédant au dossier du projet et en exécutant le script start.sh :

    cd ~/confluent-lab/labs/ecosystem
    ./start.sh

Cela démarrera notre mini cluster Kafka ainsi que le necessaire pour offrir schema-registry.

Créons le sujet appelé "stations-avro" dont nous avons besoin pour notre exemple :

    kafka-topics.sh --bootstrap-server kafka:9092 --create --topic stations-avro --partitions 1 --replication-factor 1

## Génération et consommation de messages en format AVRO

Définissez un schéma Avro pour nos enregistrements et assignez-le à une variable SCHEMA. La commande à utiliser est la suivante :

    export SCHEMA='{
        "type":"record",
        "name":"station",
        "fields":[
            {"name":"ville","type":"string"},
            {"name":"pays","type":"string"}
        ]
    }'  

Utilisons maintenant ce schéma et ajoutons-le comme argument à l'outil kafka-avro-console-producer :

    kafka-avro-console-producer --bootstrap-server kafka:9092 --topic stations-avro --property schema.registry.url=http://schema-registry:8081 --property value.schema="$SCHEMA"


    {"ville": "Pretoria", "pays": "South Africa"}
    {"ville": "Cairo", "pays": "Egypt"}
    {"ville": "Nairobi", "pays": "Kenya"}
    {"ville": "Addis Ababa", "pays": "Ethiopia"}