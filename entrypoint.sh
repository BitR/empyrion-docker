#!/bin/bash -ex

GAMEDIR="$HOME/Steam/steamapps/common/Empyrion - Dedicated Server/DedicatedServer"

cd "$HOME"
[ "$BETA" ] && ./steamcmd.sh +login anonymous +app_update 530870 -beta experimental +quit
[ -z "$BETA" ] && ./steamcmd.sh +login anonymous +app_update 530870 +quit
mkdir -p "$GAMEDIR/Logs"

rm -f /tmp/.X1-lock
Xvfb :1 -screen 0 800x600x24 &
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

cd "$GAMEDIR"

sh -c 'until [ "`netstat -ntl | tail -n+3`" ]; do sleep 1; done
sleep 5 # gotta wait for it to open a logfile
tail -F Logs/current.log ../Logs/*/*.log 2>/dev/null' &
/opt/wine-staging/bin/wine ./EmpyrionDedicated.exe -batchmode -logFile Logs/current.log "$@" &> $HOME/wine.log
