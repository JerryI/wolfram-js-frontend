#!/bin/bash

PUID=${PUID:-1000}
PGID=${PGID:-1000}

groupmod -o -g "$PGID" wljs
usermod -o -u "$PUID" wljs

chown -R wljs:wljs /wljs
chown -R wljs:wljs /home/wljs

LICENSE_DIR=/home/wljs/.WolframEngine/Licensing
mkdir -p $LICENSE_DIR
if [ ! -f $LICENSE_DIR/mathpass ]; then
  if [ -f /Licensing/mathpass ]; then
    cp /Licensing/mathpass $LICENSE_DIR/mathpass
  else
    echo "No license file available!"
    exit -1
  fi
fi
chown -R wljs:wljs /home/wljs/.WolframEngine

/usr/sbin/nginx
su - wljs -c "/usr/bin/wolframscript -f /wljs/Scripts/start.wls host 0.0.0.0 http 4000 ws 4001 ws2 4002 docs 4003 folder '/workspace'"
