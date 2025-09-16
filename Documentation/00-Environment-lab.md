# Preparation du lab
Cette documentation va vous assurez que vous aurez votre environment prêt pour les labs de Confluent et Kafka

## Pré-requis
**Un accès internet est requis**

Vous aurez besoin de: 
- Une machine virtuelle Ubuntu 22.04 de 8 Gb de RAM et 2vCPU
- Un accès terminal ( [**putty**](https://github.com/brrd/Abricotine) sur MS Windows ou Terminal sur MacOS X )

Une fois connecter via SSH sur votre machine virtuelle, executer cette commande pour télécharger les scrips requis pour le lab:

    git clone https://github.com/marcuspocus01/confluent-lab.git

Une fois téléchager, entrer dans le répertoire confluent-lab et exécuter le script d'installation: 

    cd ~/confluent-lab
    ./update-hosts.sh

Ce script va installer :
- Java JDK 21
- Docker CE et containers.io
- Kafka 4.1

Une fois complété, redémarrer ou reconnectez-vous à votre machine virtuelle afin d'assurer que tous les chemin d'accès soit bien configuré.

Ceci complète la préparation de votre laboratoire
    
