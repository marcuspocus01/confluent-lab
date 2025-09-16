#/bin/bash
if [ "$HOSTNAME" = tools ]; then
  echo "We don't need to update hosts in the tools container. Exiting."
  exit 1
fi

if grep "FUN host entries" /etc/hosts >/dev/null; then
  echo "Already done!"
  exit 0
fi

sudo sed -i '/ksqldb-server/d' /etc/hosts

cat << EOF | sudo tee -a /etc/hosts >/dev/null

# FUN host entries
127.0.0.1 kafka
127.0.0.1 zookeeper
127.0.0.1 schema-registry
127.0.0.1 connect
127.0.0.1 ksqldb-server
127.0.0.1 postgres

EOF
echo Done, isntalling required package!

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common 

echo Adding Docker official GPG key...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
echo Updating apt sources...
sudo apt update -y
echo Installing Docker...
sudo apt install -y docker-ce docker-ce openjdk-21-jdk

echo download kafka
wget https://dlcdn.apache.org/kafka/4.1.0/kafka_2.13-4.1.0.tgz 
tar -xzf kafka_2.13-4.1.0.tgz
mv kafka_2.13-4.1.0 kafka
echo moving kafka binaries to /usr/local/bin
sudo mv kafka /usr/local/bin 
echo Add to PATH in /etc/environment :/usr/local/bin/kafka/bin 
sudo sed -i 's|^PATH="\(.*\)"$|PATH="\1:/usr/local/bin/kafka/bin"|' /etc/environment
source /etc/environment
echo "Done! Please log out and back in to ensure the PATH is updated."
