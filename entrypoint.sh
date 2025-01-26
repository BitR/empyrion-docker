#!/bin/bash -ex

GAMEDIR="$HOME/Steam/steamapps/common/Empyrion - Dedicated Server/DedicatedServer"

: ${STEAMCMD}
BETACMD=
[ -z "$BETA" ] || BETACMD="-beta experimental"

./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 530870 $BETACMD $STEAMCMD +quit

mkdir -p "$GAMEDIR/Logs"

rm -f /tmp/.X1-lock
Xvfb :1 -screen 0 800x600x24 &
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

cd "$GAMEDIR"

[ "$1" = "bash" ] && exec "$@"

sh -c 'until [ "`netstat -ntl | tail -n+3`" ]; do sleep 1; done
sleep 5 # gotta wait for it to open a logfile
tail -F Logs/current.log ../Logs/*/*.log 2>/dev/null' &
/usr/lib/wine/wine64 ./EmpyrionDedicated.exe -batchmode -nographics -logFile Logs/current.log "$@" &> Logs/wine.log
