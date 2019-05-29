#!/bin/bash -ex

GAMEDIR="$HOME/Steam/steamapps/common/Empyrion - Dedicated Server/DedicatedServer"

[ -d "$GAMEDIR" ] || {
    echo "Bootstrapping game installation"

    cd "$HOME"
    [ "$BETA" ] && ./steamcmd.sh +login anonymous +app_update 530870 -beta experimental validate +quit
    [ -z "$BETA" ] && ./steamcmd.sh +login anonymous +app_update 530870 validate +quit
    mkdir "$GAMEDIR/Logs"
}

Xvfb :1 -screen 0 800x600x24 &
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

cd "$GAMEDIR"

/opt/wine-staging/bin/wine ./EmpyrionDedicated.exe -batchmode -logFile Logs/current.log "$@" # -dedicated "z:/server/Saves/Games/Game name/dedicated.yaml"
