#!/bin/bash -ex

GAMEDIR="$HOME/empyrion"

[ "$BETA" ] && ./steamcmd.sh +login anonymous +force_install_dir "$GAMEDIR" +app_update 530870 -beta experimental +quit
[ -z "$BETA" ] && ./steamcmd.sh +login anonymous +force_install_dir "$GAMEDIR" +app_update 530870 +quit
mkdir -p "$GAMEDIR/Logs"

rm -f /tmp/.X1-lock
Xvfb :1 -screen 0 800x600x24 -nolisten unix &
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

touch "$GAMEDIR"/Logs/current.log
tail -F "$GAMEDIR"/Logs/current.log &
/opt/wine-staging/bin/wine "$GAMEDIR"/EmpyrionDedicated.exe -batchmode -logFile "$GAMEDIR"/Logs/current.log "$@" &> $HOME/wine.log
