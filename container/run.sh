#!/usr/bin/env bash

LICENSE_DIR=/home/wljs/.WolframEngine/Licensing

PUID=${PUID:-1000}
PGID=${PGID:-1000}

groupmod -o -g "$PGID" wljs
usermod -o -u "$PUID" wljs

mkdir -p $LICENSE_DIR

chown -R wljs:wljs /wljs
chown -R wljs:wljs /home/wljs


function activate_wolframscript {
  
  if [ -z ${WOLFRAMID_USERNAME+x} -o -z ${WOLFRAMID_PASSWORD+x} ]; then
    # Manual activation
    su - wljs -c "wolframscript -activate"
    
    if [ $? -ne 0 ]; then
      echo "Activation failed, exiting.";
      exit -1;
    fi

  else

    su - wljs -c "expect << 'EOF'
    spawn sh -c {wolframscript -activate}
    
    expect \"Wolfram ID:\" {send \"$WOLFRAMID_USERNAME\r\"}
    expect \"Password:\" {send \"$WOLFRAMID_PASSWORD\r\"}
    
    lassign [wait] pid spawnpid os_error_flag value
    
    exit \$value
    EOF"

    if [ $? -ne 0 ]; then
      echo "Activation with provided credentials failed.";
      exit -1;
    fi

  fi

  if [ -f $LICENSE_DIR/mathpass ]; then
    # Activation success. Saving mathpass file
    cp $LICENSE_DIR/mathpass /Licensing/mathpass
  else
    echo "License file missing after activation."
    exit -1;
  fi

}

# Check if license exists else continue
if [ ! -f $LICENSE_DIR/mathpass ]; then
  # Check if license is passed to container
  if [ -f /Licensing/mathpass ]; then
    # Copy the license into the wolfram directory
    cp /Licensing/mathpass $LICENSE_DIR/mathpass
  else
    activate_wolframscript
  fi
fi
chown -R wljs:wljs /home/wljs/.WolframEngine

nginx
su - wljs -c "wolframscript -f /wljs/Scripts/start.wls host 0.0.0.0 http 4000 ws 4001 ws2 4002 docs 4003 folder '/workspace'"
