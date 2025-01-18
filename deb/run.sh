#!/bin/bash

docker run -d \
 -p 30000-30003:30000-30003/tcp \
 -p 30004:22/tcp \
 -p 30000-30004:30000-30004/udp \
 --name empyrion empyrion \
 sh -c 'tail -f /dev/null'
