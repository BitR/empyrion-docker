#!/bin/bash

#!/bin/bash

if [ $(whoami) != 'user' ]; then
 echo 'Run as user'
 exit 1
fi
kill $(ps -e | grep 'EmpyrionD' | grep -o '^ *[0-9]*')
while [ -n "$(ps -e | grep 'EmpyrionD')" ]; do
 sleep 1
done
kill $(ps -e | grep 'Xvfb' | grep -o '^ *[0-9]*')
while [ -n "$(ps -e | grep 'Xvfb')" ]; do
 sleep 1
done
