# Preparation du lab

Dans cet exercice, nous allons utiliser trois composants de la plateforme Confluent qui apportent une valeur ajoutée considérable à une plateforme de traitement de flux en temps réel basée sur Apache Kafka®. Nous utiliserons le Centre de contrôle Confluent pour surveiller et analyser notre cluster Kafka et inspecter les positions des véhicules. Nous exploiterons également l'intégration de ksqlDB au Centre de contrôle pour nous familiariser avec ksqlDB. Enfin, nous utiliserons l'interface de ligne de commande ksqlDB pour effectuer des traitements de flux simples.

## Pré-requis
Vous devez re-connecter votre session SSH avec un port forward activé. Pour ce faire, re-connectez-vous via SSH avec l'option local forward:

Exemple SSH: 

    ssh 4.x.x.x -l username -L 9021:localhost:9021

Exemple Putty: 

Exécutez le cluster Kafka en accédant au dossier du projet et en exécutant le script start.sh :

    cd ~/confluent-lab/labs/confluent-platform
    ./start.sh

Cela démarrera le cluster Kafka, le serveur ksqlDB, le centre de contrôle Confluent et le producteur. Le centre de contrôle mettra environ 2 minutes à démarrer.

Dans certaines circonstances, le producteur peut échouer et aucune donnée (ni plus) n'est générée. Si cela vous arrive, la meilleure solution est de tout recommencer. Exécutez ./stop.sh en ligne de commande, puis ./start.sh.

Une fois votre Cluster en fonction, re-créer le topic "Vehicule-positions" ainsi que le connecteur MQTT disponible dans le lab précédent.


## Surveillance et inspection de notre cluster Kafka avec Confluent Control Center

Ouvrez un navigateur et accédez à http://localhost:9021. Vous devriez voir ceci :



Si votre cluster est indiqué comme non fonctionnel, vous devrez peut-être attendre quelques instants jusqu'à ce qu'il se stabilise.

Sélectionnez controlcenter.cluster pour accéder à une vue d'ensemble du cluster présentant un ensemble de métriques qui sont des indicateurs de l'état général du cluster Kafka :

Remarquez les onglets du cluster du Centre de contrôle sur la gauche, avec les éléments « Brokers », « Topics », « Connect », etc. Nous sommes actuellement sur l'onglet « Cluster Overview ».

Dans la liste des onglets sur la gauche, sélectionnez « Topics ». Vous devriez voir ceci :