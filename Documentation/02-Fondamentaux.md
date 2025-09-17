# Preparation du lab

Dans cet exercice, nous allons utiliser un cluster Kafka de base composé d'un seul broker et d'une instance ZooKeeper. Nous allons à nouveau exécuter tous les composants de notre cluster Kafka dans des conteneurs Docker.

## Pré-requis
Exécutez le cluster Kafka en accédant au dossier du projet et en exécutant le script start.sh :

    cd ~/confluent-fundamentals/labs/fundamentals
    ./start.sh

## Travailler avec les Topics
Commençons par utiliser l’outil kafka-topics pour lister tous les sujets enregistrés sur le cluster Kafka :

    kafka-topics.sh --bootstrap-server kafka:9092 --list


Vous devriez recevoir un message vide... 

Apparemment, il n'y a aucun Topic de disponible dans le cluster, ce qui est normal...

Créons maintenant un Topic appelé « vehicle-positions » avec 6 partitions et un facteur de réplication de 1 :

    kafka-topics.sh --bootstrap-server kafka:9092 --create --topic vehicle-positions --partitions 6 --replication-factor 1

Pour vérifier les détails du Topic qui vient d'être créé, nous pouvons utiliser le paramètre --describe :

    kafka-topics.sh --bootstrap-server kafka:9092 --describe --topic vehicle-positions

nous donnant ceci :

