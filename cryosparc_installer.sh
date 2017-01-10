#!/usr/bin/env bash

# CryoSPARC web installer script
# Copyright 2016 Structura Biotechnology Inc.

# abort if any commands fail
set -e

export CRYOSPARC_LICENSE_ID="@@@CRYOSPARC-LICENSE@@@"

# at this point, the user already has a valid license ID
# but they don't have cryosparc installed.
# assume they have curl.

echo "======================================================"
echo " cryoSPARC Download Script"
echo "======================================================"
echo ""

install_dir="$HOME/cryosparc"

echo "CryoSPARC by default will install to your home directory"
echo "at the following path:"
echo "  $install_dir"
echo "Ideally, this path should be on reliable redundant storage"
echo "because this is where cryoSPARC will store its internal "
echo "database. Result data files (maps, micrographs, etc) will"
echo "be stored at a different location that you can select "
echo "later during configuration. You will also be asked for a "
echo "path to an SSD cache directory during configuration."
echo ""

got_install_dir=false
while [[ "$got_install_dir" = false ]] ; do
echo "Continue installation at"
echo "  $install_dir"
select yn in "Yes" "Change"; do
    case $yn in
        Yes )  got_install_dir=true; break ;;
        Change  ) 
            read -e -p "Enter new install directory:"
            install_dir=$REPLY
            break
            ;;
    esac
done
done

echo ""
echo "Installing at"
echo "  $install_dir"
echo ""

mkdir -p $install_dir
cd $install_dir

download_url=$(curl https://cl46ijls13.execute-api.us-east-1.amazonaws.com/dev/get/latest)
echo "Downloading latest cryoSPARC distribution..."
curl --silent "$download_url" > cryosparc.tar.gz
echo "Done."
echo ""
echo "Extracting..."
tar -xz --overwrite -f cryosparc.tar.gz
echo "Done."
echo ""
echo "Starting cryoSPARC installer..."
./install.sh 


