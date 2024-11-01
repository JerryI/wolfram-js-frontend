#!/usr/bin/env bash
#
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

function app_realpath() {
        SOURCE=$1
        while [ -h "$SOURCE" ]; do
                DIR=$(dirname "$SOURCE")
                SOURCE=$(readlink "$SOURCE")
                [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
        done
        SOURCE_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        echo "${SOURCE_DIR%%${SOURCE_DIR#*.app}}"
}

APP_PATH="/Applications/WLJS Notebook.app"
if [ -z "$APP_PATH" ]; then
        echo "Unable to determine app path from symlink : ${BASH_SOURCE[0]}"
        exit 1
fi
CONTENTS="$APP_PATH/Contents"
ELECTRON="$CONTENTS/MacOS/WLJS Notebook"
CLI="$CONTENTS/Resources/Electron/main.js"
                                        
P=$(realpath "$@")
"$ELECTRON" "$P"