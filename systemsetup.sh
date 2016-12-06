#!/usr/bin/env bash

cd ~
mkdir -p bin
cd bin

# abort if errors anywhere
set -e

setup_completed_level="0"
if [[ -e ./setup_completed_level ]] ; then
    setup_completed_level=$(cat ./setup_completed_level)
fi
echo "$setup_completed_level" > ./setup_completed_level

# LEVEL 1 ----------------------------------------------------
if [[ "$setup_completed_level" -lt "1" ]] ; then   

sudo apt-get install htop git openssh-server build-essential
setup_completed_level="1"
echo "$setup_completed_level" > ./setup_completed_level

fi

# LEVEL 2 ----------------------------------------------------
if [[ "$setup_completed_level" -lt "2" ]] ; then   

wget http://us.download.nvidia.com/XFree86/Linux-x86_64/375.20/NVIDIA-Linux-x86_64-375.20.run -O ./NVIDIA-Linux-Driver.run
sudo service lightdm stop
chmod +x NVIDIA-Linux-Driver.run
sudo ./NVIDIA-Linux-Driver.run


setup_completed_level="2"
echo "$setup_completed_level" > ./setup_completed_level


echo "Rebooting!!"
sudo reboot now

fi

# LEVEL 3 ----------------------------------------------------
if [[ "$setup_completed_level" -lt "3" ]] ; then   

wget https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda_8.0.44_linux-run -O ./NVIDIA-CUDA.run
sudo service lightdm stop
chmod +x NVIDIA-CUDA.run
sudo ./NVIDIA-CUDA.run --override

echo "Prepending NVIDIA to PATH and LD_LIBRARY_PATH..."
echo "export PATH=/usr/local/cuda/bin:\$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc

setup_completed_level="3"
echo "$setup_completed_level" > ./setup_completed_level

fi

# LEVEL 4 ----------------------------------------------------
if [[ "$setup_completed_level" -lt "4" ]] ; then   

#write out current crontab
if sudo crontab -l; then
    sudo crontab -l > mycron
else
    touch mycron
fi
#echo new cron into cron file
sudo echo "* * * * *  sync && echo 3 > /proc/sys/vm/drop_caches" >> mycron
sudo echo "@reboot nvidia-smi -pm 1" >> mycron
#install new cron file
sudo crontab mycron
sudo rm mycron

setup_completed_level="4"
echo "$setup_completed_level" > ./setup_completed_level

fi

# LEVEL 5 ----------------------------------------------------
if [[ "$setup_completed_level" -lt "5" ]] ; then   

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

setup_completed_level="5"
echo "$setup_completed_level" > ./setup_completed_level

fi


# at reboot:
# sudo nvidia-smi -pm 1