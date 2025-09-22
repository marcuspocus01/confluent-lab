# Preparation du lab

Dans cet atelier, nous utiliserons le registre de schémas de Confluent ( Schema Registry ) pour assurer la validité des schémas des messages que nous allons générer, dont les valeurs seront formatées en format Avro. Vous utiliserez également un connecteur source MQTT dans Kafka Connect pour importer des données depuis une source de données IoT.

## Pré-requis
Exécutez le cluster Kafka en accédant au dossier du projet et en exécutant le script start.sh :

    cd ~/confluent-lab/labs/ecosystem
    ./start.sh

Cela démarrera notre mini cluster Kafka ainsi que le necessaire pour offrir schema-registry.

Créons le sujet appelé "stations-avro" dont nous avons besoin pour notre exemple :

    kafka-topics --bootstrap-server kafka:9092 --create --topic stations-avro --partitions 1 --replication-factor 1

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

Nous transmettons à l'outil les informations relatives à l'emplacement du registre de schémas et au schéma lui-même sous forme de propriétés.

Ajoutons maintenant des données. Saisissez les valeurs suivantes dans le producteur :

    {"ville": "Tokyo", "pays": "Japon"}
    {"ville": "Caire", "pays": "Egypte"}
    {"ville": "Paris", "pays": "France"}
    {"ville": "Montreal", "pays": "Canada"}

Quittez kafka-avro-console-producer en appuyant sur Ctrl-c.

Exécutez kafka-avro-console-consumer pour lire les messages formatés Avro :

    kafka-avro-console-consumer --bootstrap-server kafka:9092 --topic stations-avro --from-beginning --property schema.registry.url=http://schema-registry:8081

Et vous devriez voir ce résultat :

    {"ville":"Tokyo","pays":"Japon"}
    {"ville":"Caire","pays":"Egypte"}
    {"ville":"Paris","pays":"France"}
    {"ville":"Montreal","pays":"Canada"}

Arrêtez le consommateur Avro en appuyant sur CTRL-c.

## Utilisation de Kafka Connect pour importer des données MQTT

Dans cet exercice, nous utiliserons le connecteur source MQTT de Confluent Hub (https://confluent.io/hub) pour importer des données depuis notre source MQTT de confiance.

Créez un sujet « véhicules-positions » avec 6 partitions et un facteur de réplication de 1.

    kafka-topics --bootstrap-server kafka:9092 --create --topic vehicle-positions --partitions 6 --replication-factor 1

Kafka Connect est exécuté dans notre cluster. Le connecteur MQTT est déjà installé depuis Confluent Hub. Créez un connecteur source MQTT Kafka Connect à l'aide de l'API REST Connect :

    curl -s -X POST -H 'Content-Type: application/json' -d '{
    "name" : "mqtt-source",
    "config" : {
        "connector.class" :
        "io.confluent.connect.mqtt.MqttSourceConnector",
        "tasks.max" : "1",
        "mqtt.server.uri" : "tcp://mqtt.hsl.fi:1883",
        "mqtt.topics" : "/hfp/v2/journey/ongoing/vp/train/#",
        "kafka.topic" : "vehicle-positions",
        "confluent.topic.bootstrap.servers": "kafka:9092",
        "confluent.topic.replication.factor": "1",
        "confluent.license":"",
        "key.converter":
        "org.apache.kafka.connect.storage.StringConverter",
        "value.converter":
        "org.apache.kafka.connect.converters.ByteArrayConverter"
        }
    }' http://connect:8083/connectors | jq .

Cela importera les données de position de tous les trains.

Si vous êtes curieux, vous trouverez le Dockerfile dans le sous-dossier connect du dossier du projet. Nous l'utilisons pour installer le connecteur MQTT demandé depuis Confluent Hub, par-dessus l'image officielle du connecteur Confluent.

Vérifiez si le connecteur est chargé et si le statut est « RUNNING » :

    curl -s http://connect:8083/connectors
    ["mqtt-source"]

et

    curl -s http://connect:8083/connectors/mqtt-source/status | jq .

 devrait vous retourner: 

    {
      "name": "mqtt-source",
      "connector": {
        "state": "RUNNING",
        "worker_id": "connect:8083"
      },
      "tasks": [
        {
          "id": 0,
          "state": "RUNNING",
          "worker_id": "connect:8083"
        }
      ],
      "type": "source"
    }

L'état du connecteur et de la tâche doivent être en mode "RUNNING".

Voyons voir si certaines données sont générées :

    kafka-console-consumer --bootstrap-server kafka:9092 --topic vehicle-positions --from-beginning --max-messages 5

Vous devriez recevoir quelques chose du genre: 

    {"VP":{"desi":"E","dir":"1","oper":90,"veh":1004,"tst":"2025-09-22T14:59:10.752Z","tsi":1758553150,"spd":10.29,"hdg":347,"lat":60.183242,"long":24.937426,"acc":-0.67,"dl":-56,"odo":1087,"drst":0,"oday":"2025-09-22","jrn":8357,"line":288,"start":"17:57","loc":"GPS","stop":null,"route":"3002E","occu":0}}
    {"VP":{"desi":"R","dir":"2","oper":90,"veh":6315,"tst":"2025-09-22T14:59:10.751Z","tsi":1758553150,"spd":0.00,"hdg":117,"lat":61.170346,"long":23.861853,"acc":0.00,"dl":null,"odo":null,"drst":null,"oday":"2025-09-22","jrn":9708,"line":284,"start":"18:55","loc":"GPS","stop":null,"route":"3001R","occu":0}}
    {"VP":{"desi":"I","dir":"1","oper":90,"veh":1054,"tst":"2025-09-22T14:59:11.256Z","tsi":1758553151,"spd":null,"hdg":null,"lat":null,"long":null,"acc":null,"dl":-117,"odo":28520,"drst":0,"oday":"2025-09-22","jrn":8907,"line":279,"start":"17:26","loc":"ODO","stop":null,"route":"3001I","occu":0}}
    {"VP":{"desi":"K","dir":"2","oper":90,"veh":1038,"tst":"2025-09-22T14:59:11.251Z","tsi":1758553151,"spd":21.56,"hdg":196,"lat":60.212076,"long":24.935974,"acc":0.10,"dl":-38,"odo":23752,"drst":0,"oday":"2025-09-22","jrn":9268,"line":280,"start":"17:32","loc":"GPS","stop":null,"route":"3001K","occu":0}}
    {"VP":{"desi":"I","dir":"1","oper":90,"veh":1051,"tst":"2025-09-22T14:59:11.251Z","tsi":1758553151,"spd":3.81,"hdg":46,"lat":60.251338,"long":25.011305,"acc":-1.34,"dl":0,"odo":10401,"drst":0,"oday":"2025-09-22","jrn":8909,"line":279,"start":"17:46","loc":"GPS","stop":1382501,"route":"3001I","occu":0}}
    Processed a total of 5 messages

démontrant ainsi que le connecteur source MQTT importait effectivement les positions des véhicules depuis la source.

## Nettoyage

Avant de terminer, veuillez nettoyer votre système en exécutant le script stop.sh dans le dossier du projet :

    ./stop.sh


## Conclusion
Dans cet atelier, nous avons défini un schéma Avro permettant de sérialiser et de désérialiser la partie valeur de nos messages écrits et lus depuis un sujet dans Kafka. Pour cette tâche, nous avons utilisé les deux outils de ligne de commande kafka-avro-console-producer et kafka-avro-console-consumer. Nous avons également utilisé un connecteur source MQTT dans Kafka Connect pour importer des données depuis une source de données IoT.