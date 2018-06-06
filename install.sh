#!/bin/bash

#Check if Gdrive already installed
file="/usr/bin/gdrive"
if [ -f "$file" ] then
	echo "Gdrive Already Installed"
else
	echo "Installing Gdrive"
	#Download And Install Gdrive
	if [ `getconf LONG_BIT` = "64" ] then
	    wget "https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download" -O /usr/bin/gdrive
	    chmod 777 /usr/bin/gdrive
		gdrive list
		clean
		echo "Gdrive Installed Successfully"
	else
	    wget "https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download" -O /usr/bin/gdrive
	    chmod 777 /usr/bin/gdrive
		gdrive list
		clean
		echo "Gdrive Installed Successfully"
	fi
fi
