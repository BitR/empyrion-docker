#!/bin/bash

docker run -d \
 -p 30000-30003:30000-30003/tcp \
 -p 30004:22/tcp \
 -p 30000-30004:30000-30004/udp \
 --name empyrion empyrion \
 sh -c 'tail -f /dev/null'

docker exec -d empyrion .ssh/sshd.sh
sleep 1
docker cp empyrion:/home/user/.ssh/user .
docker cp empyrion:/home/user/.ssh/user-cert.pub .
