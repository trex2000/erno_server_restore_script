#!/bin/sh 
echo "Started oscam update"
mkdir oscam-svn 
main_url="http://www.streamboard.tv/svn/oscam/trunk"
svn checkout $main_url oscam-svn
cd oscam-svn
svn update
if [ ! -d "build" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir build
fi
sh ./config.sh --enable all
sh ./config.sh --enable CARDREADER_PCSC
cd build
cmake ..
#make 
make USE_PCSC=1
systemctl stop oscam 
make install
systemctl restart oscam
sleep 10
