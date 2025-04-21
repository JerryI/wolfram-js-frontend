set -eux -o pipefail #Exit right after any command fails.

link_name="/usr/bin/wolfram"

if [[ $WE_MODE == "install" ]]; then

    #Define variables {

    #You can set actual version numbers (e.g. "12.0") or an asterisk "*".
    #In the latter case, there should be no wolfram-engine installed already.
    wolfram_version="*"

    install_script_name="$(mktemp --suffix=.sh --dry-run /tmp/install_wolfram_XXXX)"

    wget "https://archive.raspberrypi.org/debian/pool/main/w/wolfram-engine/wolfram-engine_14.1.0+202408191410_arm64.deb"
    

    #The value must be the same as that of `TEMPDIR` variable in the `wget`-ed script.
    working_directory="/tmp/wolfram-engine-install"

    #} Define variables

    echo "[2/5] Preparing..."

    install -vDm644 *engine*.deb -t ${working_directory}/wolfram_engine

    pushd "${working_directory}" > /dev/null
    cd wolfram_engine/
    ar x *engine*.deb
    mkdir data

    echo "[3/5] Extracting..."
    tar -C data -xf data.tar.*

    echo "[4/5] Installing..."
    sudo cp -r data/opt/* /opt
    sudo ln -s /opt/Wolfram/WolframEngine/${wolfram_version}/Executables/wolfram "${link_name}"

    echo "[5/5] Exiting..."
    # popd > /dev/null #This is not needed because this script is intended to be executed on a sub-shell.
    rm -rf "${working_directory}" "${install_script_name}"

    echo "Done."

elif [[ $WE_MODE == "uninstall" ]]; then

    echo "Uninstalling..."
    sudo rm -rf /opt/Wolfram "${link_name}" #Note this uninstalls all versions of wolfram engines.
    echo "Done."

else

    #`WE_MODE` is named after "Wolfram Engine".
    echo "The value of \$WE_MODE [ $WE_MODE ] is illegal."
    echo
    echo "Usage"
    echo "  WE_MODE=install bash <this script>"
    echo "  WE_MODE=uninstall bash <this script>"

fi