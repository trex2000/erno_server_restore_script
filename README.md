# erno_server_restore_script
This is a restore script used to install and configure an oscam server on a brand new ubuntu server installation.

Usage:

Step 1: Update software repository:
>sudo apt-get update

Step 2: Install git:
>sudo apt-get install git

Step 3: Go into root mode:
>sudu su

(Enter root password here)

Step 4: Checkout from git repository

4.1 If it is a new installation:
>mkdir /var/bin

>chmod 777 /var/bin

>git clone https://github.com/trex2000/erno_server_restore_script.git

(Copy the URL of the repository from the green button above)

>cd ./erno_server_restore_script

4.2 If it is an existing installation:
>cd /var/bin/erno_server_restore_script

>git fetch https://github.com/trex2000/erno_server_restore_script.git

Step 5:  Make script executable:
>chmod 777 *.sh

Step 6: Launch restore script and follow onscreeen instructions:
>./restore.sh



