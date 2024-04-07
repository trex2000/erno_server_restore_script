#!/bin/sh 
#configure area
work_dir="/home/erno2/erno_server_restore_script"
oscam_url="https://git.streamboard.tv/common/oscam.git/ oscam-svn"
#pcscd_url="https://salsa.debian.org/rousseau/"
pcscd_url="https://github.com/LudovicRousseau"
#ccid_url="https://salsa.debian.org/rousseau/"
ccid_url="https://github.com/LudovicRousseau/"

#script area
DIRECTORY_CCID="${work_dir}/CCID"
DIRECTORY_PCSC="${work_dir}/PCSC"
DIRECTORY_OSCAM="${work_dir}/oscam-svn"
cd $work_dir

echo "Started ccid update"
if curl -s -m 5 --head  --request GET $ccid_url | grep "200" > /dev/null; then 
    if [ ! -d "$DIRECTORY_CCID" ]; then
	echo "New installation of CCID. Cloning git"
	git clone --recursive "${ccid_url}CCID.git"
	cd $DIRECTORY_CCID
    else	
	echo "Existing installation of CCID. Fetching updates"
	cd $DIRECTORY_CCID
	git fetch  "${ccid_url}CCID.git"
    fi
else
    echo Github is down, cannot update CCID
    exit
fi
./bootstrap
./configure
make
make install

cd $work_dir
echo "Started pccd update"
if curl -s -m 5 --head  --request GET $pcscd_url | grep "200" > /dev/null; then 
    if [ ! -d "$DIRECTORY_PCSC" ]; then
	echo "New installation. Cloning git"
	git clone "${pcscd_url}PCSC.git"
	cd $DIRECTORY_PCSC
    else	
	echo "Existing installation. Fetching updates"
	cd $DIRECTORY_PCSC
	git fetch  "${pcscd_url}PCSC.git"
    fi
else
    echo Github is down, cannot update pcscd
    exit
fi
./bootstrap
./configure --enable-libudev  -enable-debugatr --disable-libusb --enable-usbdropdir=/usr/local/lib/pcsc/drivers
make
systemctl stop pcscd
make install
systemctl enable pcscd
systemctl daemon-reload
systemctl start pcscd

cd $work_dir
echo "Started oscam update"
if curl -s -m 5 --head  --request GET $oscam_url | grep "200" > /dev/null; then 
    if [ ! -d "$DIRECTORY_OSCAM" ]; then
	echo "New installation of OScam"
	git clone $oscam_url
	cd $DIRECTORY_OSCAM
    else	
	echo "Existing installation of OSCAM. Getting updates"
	cd $DIRECTORY_OSCAM
	git fetch --all
    fi
    if [ ! -d "build" ]; then
	mkdir build
    fi
    cd build
    cmake ..
    make
    #echo all done, restarting services
    systemctl stop oscam 
    make install
    systemctl restart oscam
else
    echo "SVN repo  is down:"
    echo $oscam_url
    echo "Cannot update OScam"
fi
