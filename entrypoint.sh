#!/bin/bash

cd ~
if [ ! -d empyrion ]; then
steamcmd/steamcmd.sh +force_install_dir ~/empyrion +login anonymous +app_update 530870 +quit &> steamlog
fi
if [ -z "$(ps -e | grep 'sshd')" ]; then
.ssh/sshd.sh > /dev/null
fi
rm -f /tmp/.X1-lock
if [ -z "$(ps -e | grep 'Xvfb')" ]; then
Xvfb :1 -screen 0 1x1x8 &> /home/user/xlog &
fi
export DISPLAY=:1
cd ~/empyrion/DedicatedServer
wine EmpyrionDedicated.exe -batchmode -nographics -logFile /home/user/emplog -dedicated /home/user/conf.yaml &> /home/user/winlog
