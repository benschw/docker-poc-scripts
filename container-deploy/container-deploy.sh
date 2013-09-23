#/bin/bash

WILDCARD_NAME="io.fliglio.com"

TAG=$1  # jbfink/wordpress:latest


NAME=$(echo $TAG | awk -F':' '{print $1}') # jbfink/wordpress

CLEAN_NAME=$(echo $NAME | tr / -) # jbfink-wordpress


CONTAINER_ID=$(sudo docker run -d $TAG)
CONTAINER_PORT=$(sudo docker port $CONTAINER_ID 80)
CONTAINER_BRIDGE=$(sudo docker inspect $CONTAINER_ID | grep Bridge | cut -d":" -f2 | cut -d'"' -f2)
CONTAINER_IP=$(/sbin/ifconfig  $CONTAINER_BRIDGE | sed -n '2 p' | awk '{print $2}' | cut -d":" -f2)

REDIS_HOST="$CONTAINER_IP" # its all the same thing on one node
REDIS_PORT="6379"

echo redis-cli -h $REDIS_HOST -p $REDIS_PORT rpush frontend:$CLEAN_NAME.$WILDCARD_NAME $CLEAN_NAME

redis-cli -h $REDIS_HOST -p $REDIS_PORT rpush frontend:$CLEAN_NAME.$WILDCARD_NAME $CLEAN_NAME
redis-cli -h $REDIS_HOST -p $REDIS_PORT rpush frontend:$CLEAN_NAME.$WILDCARD_NAME http://$CONTAINER_IP:$CONTAINER_PORT

exit


redis-cli -h 172.17.42.1 -p 6379 lrange 0 -1 jbfink-wordpress.io.fliglio.com