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
>git clone [REPO_URL]

(Copy the URL of the repository from the green button above)

Step 5:  Make script executable:
>chmod 777 *.sh

Step 6: Launch restore script and follow onscreeen instructions:
>./restore.sh



