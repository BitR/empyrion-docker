#!/bin/bash

if [ $(whoami) != 'user' ]; then
 echo 'Run as user'
 exit 1
fi
cd ~
if [ ! -d empyrion ]; then
 steamcmd/steamcmd.sh +force_install_dir ~/empyrion +login anonymous +app_update 530870 +quit &> steamlog
fi
rm -f /tmp/.X1-lock
if [ -z "$(ps -e | grep 'Xvfb')" ]; then
 Xvfb :1 -screen 0 1x1x8 &> /home/user/logxvf &
fi
if -z "$(ps -e | grep 'Empyrion')" ]; then
 export DISPLAY=:1
 cd empyrion/DedicatedServer
 wine EmpyrionDedicated.exe -batchmode -nographics -logFile /home/user/logemp -dedicated /home/user/conf.yaml &> /home/user/logwin
else
 echo 'Empyrion appears to be running'
 exit 2
fi
