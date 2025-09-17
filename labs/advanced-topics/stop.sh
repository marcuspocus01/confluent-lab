#! /bin/bash

# remove all consumer containers
sudo docker container ls | grep sample-consumer | awk '{ print $1 }' | xargs docker container rm -f
# Remove the producer
sudo docker container rm -f producer
# remove the Kafka cluster
sudo docker compose down -v
