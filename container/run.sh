#!/usr/bin/env bash

set -eux -o pipefail

PUID=${PUID:-1000}
PGID=${PGID:-1000}

groupmod -o -g "$PGID" wljs
usermod -o -u "$PUID" wljs

chown -R wljs:wljs /wljs
chown -R wljs:wljs /home/wljs

nginx
su - wljs -c "wolframscript -activate"
su - wljs -c "wolframscript -f /wljs/Scripts/start.wls host 0.0.0.0 http 4000 ws 4001 ws2 4002 docs 4003"
