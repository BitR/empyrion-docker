#!/bin/bash -ex

GAMEDIR="$HOME/Steam/steamapps/common/Empyrion - Dedicated Server/DedicatedServer"

cd "$HOME"
[ "$BETA" ] && ./steamcmd.sh +login anonymous +app_update 530870 -beta experimental +quit
[ -z "$BETA" ] && ./steamcmd.sh +login anonymous +app_update 530870 +quit
mkdir -p "$GAMEDIR/Logs"

Xvfb :1 -screen 0 800x600x24 &
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

cd "$GAMEDIR"

tail -F Logs/current.log &
/opt/wine-staging/bin/wine ./EmpyrionDedicated.exe -batchmode -logFile Logs/current.log "$@" &> $HOME/wine.log
