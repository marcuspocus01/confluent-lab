# Preparation du lab

Dans cet exercice, nous allons utiliser un cluster Kafka de base composé d'un seul broker et d'une instance ZooKeeper. Nous allons à nouveau exécuter tous les composants de notre cluster Kafka dans des conteneurs Docker.

## Pré-requis
Exécutez le cluster Kafka en accédant au dossier du projet et en exécutant le script start.sh :

    cd ~/confluent-lab/labs/fundamentals
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

    Topic: vehicle-positions	TopicId: GD1f0i_bS1eEqFS-36RP0Q	PartitionCount: 6	ReplicationFactor: 1	Configs: 
	Topic: vehicle-positions	Partition: 0	Leader: 1	Replicas: 1	Isr: 1	Elr: N/A	LastKnownElr: N/A
	Topic: vehicle-positions	Partition: 1	Leader: 1	Replicas: 1	Isr: 1	Elr: N/A	LastKnownElr: N/A
	Topic: vehicle-positions	Partition: 2	Leader: 1	Replicas: 1	Isr: 1	Elr: N/A	LastKnownElr: N/A
	Topic: vehicle-positions	Partition: 3	Leader: 1	Replicas: 1	Isr: 1	Elr: N/A	LastKnownElr: N/A
	Topic: vehicle-positions	Partition: 4	Leader: 1	Replicas: 1	Isr: 1	Elr: N/A	LastKnownElr: N/A
	Topic: vehicle-positions	Partition: 5	Leader: 1	Replicas: 1	Isr: 1	Elr: N/A	LastKnownElr: N/A


Nous voyons une ligne pour chaque partition créée. Pour chaque partition, nous obtenons le broker leader, l'emplacement du réplica et la liste des réplicas synchronisés (ISR). Dans notre cas, la liste semble simple, car nous n'avons qu'un seul réplica, placé sur le broker 1.

Essayez maintenant de créer un autre Topic appelé « test-topic » avec 3 partitions et un facteur de réplication 1.

Listez tous les sujets de votre cluster Kafka. 

    kafka-topics.sh --bootstrap-server kafka:9092 --list

Vous devriez voir ceci :

    test-topic
    vehicle-positions

Pour supprimer le Topic « test-topic », utilisez la commande suivante :

    kafka-topics.sh --bootstrap-server kafka:9092 --delete --topic test-topic

Vérifiez que le Topic a disparu en répertoriant tous les Topics du cluster.


## Produire et consommer des données

Ajoutons des données à un Topic « sample-topic » en exécutant l'outil en ligne de commande kafka-console-producer. Nous utiliserons ensuite l'outil kafka-console-consumer pour consommer les mêmes données.

Basé sur les commandes disponible plus haut:
1. Utilisez l'outil kafka-topics pour créer un sujet « sample-topic » avec 3 partitions et un facteur de réplication de 1.


        kafka-topics.sh --bootstrap-server kafka:9092 --create --topic sample-topic --partitions 3 --replication-factor 1

2. Vérifiez que le Topic est bien créé en répertoriant tous les Topics du cluster.

        kafka-topics.sh --bootstrap-server kafka:9092 --list


Exécutez l'outil de ligne de commande kafka-console-producer :

    kafka-console-producer.sh --bootstrap-server kafka:9092 --topic sample-topic

Tapez Hello à l'invite et appuyez sur <Entrée> :

    >Hello

Tapez quelques lignes supplémentaires à l'invite (chacune terminée par <Entrée>) :

    >world
    >Kafka
    >is
    >cool!

et appuyez sur CTRL-d lorsque vous avez terminé pour quitter le producteur.

Utilisez maintenant kafka-console-consumer pour consommer toutes les données depuis le début du topic "sample-topic" :

    kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic sample-topic --from-beginning

Dans mon cas, le résultat ressemble à ceci :

    Hello
    Kafka
    is
    world
    cool!

Remarquez que l'ordre des éléments saisis est brouillé. Prenez un moment pour réfléchir à ce qui se passe. Discutez de vos conclusions en classe.

Terminez le consommateur en appuyant sur CTRL-c

Jusqu'à présent, nous avons produit et consommé des données sans clé. Exécutons maintenant le producteur de manière à pouvoir également saisir une clé pour chaque valeur :

    kafka-console-producer.sh --bootstrap-server kafka:9092 --topic sample-topic --property parse.key=true --property key.separator=,

Les deux derniers paramètres indiquent au producteur d'attendre une clé et d'utiliser la virgule (,) comme séparateur entre la clé et la valeur à l'entrée.

Entrez quelques valeurs:

    >1, pommes
    >2, poires
    >3, noix
    >4, choux
    >5, oranges

et appuyez sur CTRL-d pour quitter le producteur.

Utilisons maintenant l'outil consommateur de la console et configurons-le pour qu'il génère des clés et des valeurs :

    kafka-console-consumer --bootstrap-server kafka:9092 --topic sample-topic --from-beginning --property print.key=true

le résultat dans mon cas ressemble à ceci :

    null    Hello
    null    Kafka
    1       pomme
    5       oranges
    null    is
    4       choux
    null    world
    null    cool!
    2       poires
    3       noix

Remarquez que la valeur null est renvoyée pour la clé des valeurs que nous avons initialement saisies sans définir de clé.

La question se pose à nouveau : « Pourquoi l’ordre de lecture des éléments du Topic n’est-il pas celui dans lequel vous avez créé les messages ? »

Appuyez sur CTRL-c pour quitter le consommateur.

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

Dans cet exercice, nous avons créé un cluster Kafka simple. Nous avons ensuite utilisé l'outil kafka-topics pour répertorier, créer, décrire et supprimer des Topics. Nous avons ensuite utilisé les outils kafka-console-producer et kafka-console-consumer pour produire et exploiter des données de et vers Kafka.