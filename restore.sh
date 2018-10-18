#!/bin/bash
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31m This script must be run as root" 1>&2
   echo -e "\e[31m Write to command line: sudo su" 1>&2
   exit 1
fi
CURRDIR=$(pwd)
apt-get install realpath -y
cd $CURRDIR
echo Restoring...
read -p "Would you like to install Midnight Commander? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    sudo apt-get install mc -y
fi
read -p "Would you like to install locate? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    sudo apt-get install locate -y
fi

echo -e "\e[31mRUN THIS ONLY ONE TIME!!!!"
echo -e "\e[39m"
read -p "Would you like to Update fstab and create mount points?<y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    echo Updating fstab
    mkdir /var/log/ramdisk
    echo "tmpfs    /var/log/ramdisk    tmpfs    defaults,noatime,nosuid,size=64M    0 0" >> /etc/fstab
    echo Creating mount points
    sudo mount /var/log/ramdisk
fi

read -p "Would you like to install crond? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    sudo apt-get install cron -y
    
fi
read -p "Would you like to install webserver+php+mysql? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    sudo apt-get install lighttpd -y
    sudo apt-get install mysql-server -y
    sudo apt-get install php7.2-common php7.2-cgi php7.2 -y
    sudo apt-get install php7-mysql -y
    sudo lighty-enable-mod fastcgi-php -y
    sudo systemctl restart lighttpd -y
    sudo chown www-data:www-data /var/www
    sudo chmod 775 /var/www
    sudo usermod -a -G www-data erno
    sudo apt-get install phpmyadmin -y
    sudo apt-get install -f -y
fi

read -p "Would you like to install oscam? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    sudo apt install -y subversion
    sudo apt-get install build-essential -y
    sudo apt-get install libusb-1.0-0-dev -y
    sudo apt-get install cmake -y
    sudo apt-get install libssl-dev -y
    sudo apt-get install pcscd -y
    echo "Creating /var/etc/oscam folder"
    sudo mkdir /var/etc/
    sudo mkdir /var/etc/oscam
    sudo chmod 777 /var/etc/oscam
    echo "Install service file"
    echo "
[Unit]
Description=oscam
After=network.target

[Service]
Type=forking
PIDFile=/run/oscam.pid
ExecStart=/usr/local/bin/oscam  -b -r 2 -B /run/oscam.pid -c /var/etc/oscam -p 512
ExecStop=/usr/bin/rm /run/oscam.pid
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
    " > /etc/systemd/system/oscam.service
    systemctl enable oscam.service
    sh ./update_oscam.sh
    echo -e "\e[32mAll done. Copy oscam config files to /var/etc/oscam folder"
    echo -e "\e[39m"

    echo -e "\e[31mRUN THIS ONLY ONE TIME!!!!"
    echo -e "\e[39m"
    read -p "Would you like to add automatic restart of oscam? <y/N> " prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
	#write out current crontab
	crontab -l > crontab.bak
	#echo new cron into cron file
	echo "54 3 * * *  root /usr/bin/systemctl restart oscam" >> crontab.bak
	#install new cron file
	crontab crontab.bak
	rm crontab.bak
    fi
fi
