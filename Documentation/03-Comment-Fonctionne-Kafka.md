# Preparation du lab

Dans cet atelier, nous allons créer un consommateur Java simple. Ce Consumer lira les données du sujet « positions de véhicules » que le producteur, présenté lors d'un atelier précédent, produit à partir de notre source IoT fiable. Dans un deuxième temps, nous ajouterons d'autres consommateurs (ou le groupe de consommateurs) et analyserons son effet.

## Pré-requis
Exécutez le cluster Kafka en accédant au dossier du projet et en exécutant le script start.sh :

    cd ~/confluent-lab/labs/advanced-topics
    ./start.sh

Cela démarrera notre mini cluster Kafka, créera le sujet « véhicules-positions », puis démarrera le producteur qui écrit les données de notre source IoT vers le sujet.

## Batir le Consumer java dans Docker

Pour nous préparer à l'ajout de plusieurs consommateur, nous allons préparer l'exécution d'une instance de consommateur comme un conteneur Docker. Par la suite, nous pourrons exécuter plusieurs conteneur en paralelle. Nous disposons d'un Dockerfile à cet effet dans notre dossier de projet.

Accédez au sous-dossier consommateur du dossier du projet :

    cd ~/confluent-fundamentals/labs/advanced-topics/consumer

Pour créer l'image Docker, exécutez le script build-consumer.sh :

    ./build-image.sh

please be patient, this takes a moment or two.

## Exécution du Consumer

Exécutez votre premier consommateur (une instance de l'image Docker que vous venez de créer) comme suit :

    ./run-consumer.sh

Vous devriez voir un identifiant long, comme ceci :

    97d34f47f2e477f66f360cd6b0e83bb...

indiquant qu'un conteneur portant l'ID ci-dessus exécute votre consommateur (en arrière-plan, comme un démon)

Utilisons l'outil kafka-consumer-groups pour voir ce qui se passe :


    kafka-consumer-groups --bootstrap-server kafka:9092 --group vp-consumer --describe

    GROUP           TOPIC             PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                                 HOST            CLIENT-ID
    vp-consumer     vehicle-positions 5          4867            14681           9814            consumer-vp-consumer-1-7a214cf1-d9f4-4da3-80dd-0e5d565bdfab /172.18.0.4     consumer-vp-consumer-1
    vp-consumer     vehicle-positions 4          4347            14009           9662            consumer-vp-consumer-1-7a214cf1-d9f4-4da3-80dd-0e5d565bdfab /172.18.0.4     consumer-vp-consumer-1
    vp-consumer     vehicle-positions 3          2447            14045           11598           consumer-vp-consumer-1-7a214cf1-d9f4-4da3-80dd-0e5d565bdfab /172.18.0.4     consumer-vp-consumer-1
    vp-consumer     vehicle-positions 2          2458            14669           12211           consumer-vp-consumer-1-7a214cf1-d9f4-4da3-80dd-0e5d565bdfab /172.18.0.4     consumer-vp-consumer-1
    vp-consumer     vehicle-positions 1          2441            13638           11197           consumer-vp-consumer-1-7a214cf1-d9f4-4da3-80dd-0e5d565bdfab /172.18.0.4     consumer-vp-consumer-1
    vp-consumer     vehicle-positions 0          2440            14344           11904           consumer-vp-consumer-1-7a214cf1-d9f4-4da3-80dd-0e5d565bdfab /172.18.0.4     consumer-vp-consumer-1

Nous constatons qu'un seul client (consumer-vp-consumer-1-7a214cf1-d9f4-4da3-80dd-0e5d565bdfab) consomme les 6 partitions. Nous pouvons également observer le décalage actuel sur chaque partition. Ce décalage indique si le groupe de consommateurs est en retard.

Répétez la commande ci-dessus plusieurs fois et observez comment le LAG se comporte.

Vous pouvez utiliser la commande watch pour observer l'évolution du LAG au fil du temps :

    watch kafka-consumer-groups --bootstrap-server kafka:9092 --group vp-consumer --describe

Terminez la surveillance en appuyant sur Ctrl-c.

Exécutons un autre consommateur et évoluons jusqu’à 2 instances :

    ./run-consumer.sh

Et décrire à nouveau le groupe de consommateurs vp-consumer :

    kafka-consumer-groups --bootstrap-server kafka:9092 --group vp-consumer --describe

Nous constatons maintenant qu'il existe deux instances de consommateurs. Un rééquilibrage transparent de la charge de travail a eu lieu !
Veuillez également noter que le LAG ne croît plus aussi vite qu'avant, car nous avons parallélisé la charge de travail.

Augmentez encore la taille du groupe de consommateurs et observez le comportement du décalage du consommateur.

Que se passe-t-il si vous augmentez la taille du groupe de consommateurs à plus de 6 instances ?

## Nettoyage

Avant de terminer, veuillez nettoyer votre système en exécutant le script stop.sh dans le dossier du projet :

    ./stop.sh

## Conclusion
Dans cet atelier, nous avons créé et exécuté un consommateur Kafka simple. Nous avons ensuite fait évoluer le consommateur et analysé son effet à l'aide de l'outil kafka-consumer-groups.