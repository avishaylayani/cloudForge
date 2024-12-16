#!/bin/bash
current=""
while true; do
	latest=`ec2-metadata --public-ipv4`
	echo "public-ipv4=$latest"
	if [ "$current" == "$latest" ]
	then
		echo "ip not changed"
	else
		echo "ip has changed - updating"
		current=$latest
		echo url="https://www.duckdns.org/update?domains=prod-cloudforge&token=d743e5a8-5cfa-46aa-82f9-65f1969ed90d&ip=" | curl -k -o ~/duckdns/duck.log -K -
	fi
	sleep 5m
done