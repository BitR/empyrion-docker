#!/bin/bash

docker exec -d empyrion .ssh/sshd.sh
while [ -z "$(docker exec -t empyrion ls .ssh | grep 'user-cert.pub')" ]; do
 sleep 1
done
docker cp empyrion:/home/user/.ssh/user .
docker cp empyrion:/home/user/.ssh/user-cert.pub .
docker exec -d empyrion rm .ssh/user
