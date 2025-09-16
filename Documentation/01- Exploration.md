# Preparation du lab

Dans cet exercice, nous allons explorer un cluster Kafka très simple composé d'un seul broker et d'une seule instance ZooKeeper. 

Nous exécuterons également un client Kafka simple, un Producer, qui écrit des données depuis une source publique dans Kafka. Nous utiliserons ensuite un outil Kafka appelé kafka-console-consumer pour lire ces données depuis Kafka.

Si les termes broker, ZooKeeper et client Kafka ne vous disent rien, ne vous inquiétez pas ; nous les présenterons en détail dans le prochain module.

## Pré-requis
**Environment Lab complété**

## Exécution d'un cluster Kafka simple
Nous allons exécuter tous les composants de notre cluster Kafka simple dans des conteneurs Docker. ( 1 Producer, 1 ZooKeeper et 1 Consumer )

Pour cela, accédez au dossier du projet et exécutez le script start.sh :


       cd ~/confluent-fundamentals/labs/exploring
       ./start.sh

Le démarrage du cluster prendra un certain temps, soyez patient. Vous obtiendrez un résultat similaire à ceux-ci (raccourci pour plus de lisibilité) :



    ✔ Network exploring_confluent  Created       0.1s 
    ✔ Container kafka              Started       0.4s 
    Waiting for Kafka to launch on 9092...
    Kafka is now ready!
    Creating 'vehicle-positions' topic...
    Created topic vehicle-positions.
    Topic created.

    Building and running producer...
    Status: Downloaded newer image for cnfltraining/vp-producer:v2
    6093dc364a586a50f409287d1f1da91c1bfa19cea8b09c67000be596d54d8e7c
    Producer up and running!

Utilisez ensuite l'outil kafka-console-consumer installé sur votre machine virtuelle de laboratoire pour lire les données que le producteur écrit dans Kafka. Pour ce faire, utilisez la commande suivante :

    kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic vehicle-positions

Après quelques instants, vous devriez voir les enregistrements s'afficher rapidement sur votre terminal. Ces enregistrements sont des données en temps réel provenant d'une source MQTT. Chaque enregistrement correspond à la position d'un véhicule (bus, tram ou train) du fournisseur de transports publics finlandais. Les données se présentent comme suit (en résumé) :

    {"VP":{"desi":"566","dir":"1","oper":22,"veh":1084,"tst":"2025-09-16T16:07:21.755Z","tsi":1758038841,"spd":5.47,"hdg":223,"lat":60.215341,"long":24.657604,"acc":0.98,"dl":-309,"odo":17529,"drst":0,"oday":"2025-09-16","jrn":434,"line":818,"start":"18:31","loc":"GPS","stop":2611264,"route":"5566","occu":0}}
    
    {"VP":{"desi":"M2","dir":"2","oper":50,"veh":177,"tst":"2025-09-16T16:07:21Z","tsi":1758038841,"spd":19.62,"hdg":277,"lat":60.163543543,"long":24.904549413,"acc":null,"dl":null,"odo":null,"drst":null,"oday":"2025-09-16","start":"18:41","loc":"MAN","stop":null,"route":"31M2","occu":0,"seq":1}}
    
    {"VP":{"desi":"20","dir":"2","oper":22,"veh":1258,"tst":"2025-09-16T16:07:21.255Z","tsi":1758038841,"spd":5.80,"hdg":167,"lat":60.199254,"long":24.883416,"acc":-0.55,"dl":-77,"odo":3991,"drst":0,"oday":"2025-09-16","jrn":2127,"line":51,"start":"18:53","loc":"GPS","stop":1301126,"route":"1020","occu":0}}
    
    {"VP":{"desi":"M2","dir":"1","oper":50,"veh":173,"tst":"2025-09-16T16:07:21Z","tsi":1758038841,"spd":8.63,"hdg":83,"lat":60.174789685,"long":24.80294908,"acc":null,"dl":null,"odo":null,"drst":null,"oday":"2025-09-16","start":"19:08","loc":"MAN","stop":2211601,"route":"31M2","occu":0,"seq":1}}
    
    {"VP":{"desi":"M1","dir":"2","oper":50,"veh":223,"tst":"2025-09-16T16:07:21Z","tsi":1758038841,"spd":16.64,"hdg":277,"lat":60.18704194,"long":24.98093479,"acc":null,"dl":null,"odo":null,"drst":null,"oday":"2025-09-16","start":"18:57","loc":"MAN","stop":null,"route":"31M1","occu":0,"seq":1}}

Arrêtez le consommateur en appuyant sur Ctrl-c.

MQTT signifie Message Queuing Telemetry Transport. Il s'agit d'un système léger de publication et d'abonnement permettant de publier et de recevoir des messages en tant que client. MQTT est un protocole de messagerie simple, conçu pour les appareils à faible bande passante. Il constitue donc la solution idéale pour les applications de l'Internet des objets (IoT).

## Nettoyage

Avant de terminer, veuillez nettoyer votre système en exécutant le script stop.sh dans le dossier du projet :

    ./stop.sh

Vous devriez voir ceci:

    Stopping containers and destroying data volumes...
        producer
        kafka
        [+] Running 1/1
    ✔ Network exploring_confluent  Removed  0.1s 
    Lab successfully stopped

## Conclusion

Dans cet exercice, nous avons créé un pipeline de données temps réel simple, optimisé par Kafka. Nous avons écrit des données provenant d'une source de données IoT publique dans un cluster Kafka simple. Ces données ont ensuite été consommées avec un outil Kafka simple appelé kafka-console-consumer.