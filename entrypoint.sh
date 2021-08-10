#!/bin/bash -ex

[ "$UID" = 0 ] && {
    mkdir -p ~user/Steam
    chown user: ~user/Steam
    runuser -u user "$0" "$@"
    exit 0
} || :

GAMEDIR="$HOME/Steam/steamapps/common/Empyrion - Dedicated Server/DedicatedServer"
SCENARIODIR="$HOME/Steam/steamapps/common/Empyrion - Dedicated Server/Content/Scenarios"
MODSDIR="$HOME/Steam/steamapps/workshop/content/383120"

cd "$HOME"
set +e
[ "$BETA" ] && ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +"workshop_download_item 383120 2550354956" +app_update 530870 -beta experimental +quit
[ -z "$BETA" ] && ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +"workshop_download_item 383120 2550354956" +app_update 530870 +quit
set -e
mkdir -p "$GAMEDIR/Logs"

cp "$MODSDIR/2550354956" "$SCENARIODIR/ReforgedEden" -R
chown ubuntu:ubuntu -R "$SCENARIODIR/ReforgedEden"

rm -f /tmp/.X1-lock
Xvfb :1 -screen 0 800x600x24 &
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

cd "$GAMEDIR"

[ "$1" = "bash" ] && exec "$@"

sh -c 'until [ "`netstat -ntl | tail -n+3`" ]; do sleep 1; done
sleep 5 # gotta wait for it to open a logfile
tail -F Logs/current.log ../Logs/*/*.log 2>/dev/null' &
/opt/wine-staging/bin/wine ./EmpyrionDedicated.exe -batchmode -nographics -logFile Logs/current.log "$@" &> Logs/wine.log
