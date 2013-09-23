#/bin/bash

WILDCARD_NAME="io.fliglio.com"

TAG=$1  # jbfink/wordpress:latest
INSTANCES=$2 # defaults to 1 container to be instantiated

REPO=$(echo $TAG | awk -F':' '{print $1}') # jbfink/wordpress
NAME=$(echo $REPO | tr / -) # jbfink-wordpress

# since hipache and redis are on this host, lets grab their info like this
REDIS_ID=$(docker ps | grep hipache | awk '{print $1}')
REDIS_BRIDGE=$(docker inspect $REDIS_ID | grep Bridge | cut -d":" -f2 | cut -d'"' -f2)
REDIS_IP=$(/sbin/ifconfig  $REDIS_BRIDGE | sed -n '2 p' | awk '{print $2}' | cut -d":" -f2)
REDIS_PORT="6379"


## stop

# stop all containers running instances from supplied repo
docker ps  | grep $REPO | awk '{print $1}' | sed ':a;N;$!ba;s/\n/ /g' | xargs docker stop

# clear hipache config referencing this repo
redis-cli -h $REDIS_IP -p $REDIS_PORT del frontend:$NAME.$WILDCARD_NAME


## start

for i in {1..$INSTANCES}; do
	# start container
	CONTAINER_ID=$(docker run -d $TAG)
	CONTAINER_PORT=$(docker port $CONTAINER_ID 80)
	CONTAINER_BRIDGE=$(docker inspect $CONTAINER_ID | grep Bridge | cut -d":" -f2 | cut -d'"' -f2)
	CONTAINER_IP=$(/sbin/ifconfig  $CONTAINER_BRIDGE | sed -n '2 p' | awk '{print $2}' | cut -d":" -f2)

	# configure hipache
	redis-cli -h $REDIS_IP -p $REDIS_PORT rpush frontend:$NAME.$WILDCARD_NAME $NAME
	redis-cli -h $REDIS_IP -p $REDIS_PORT rpush frontend:$NAME.$WILDCARD_NAME http://$CONTAINER_IP:$CONTAINER_PORT

done

exit


redis-cli -h 172.17.42.1 -p 6379 lrange frontend:jbfink-wordpress.io.fliglio.com 0 -1
