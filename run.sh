#!/bin/bash

# Load Settings file 
. .settings

if [ "$backupMode" == "gdrive" ]; then		
   #Check Gdrive backup Root folder exists on gdrive
   gdriveRSID=$(gdrive list --no-header | grep $gdriveDir | grep dir | awk '{ print $1}')
   if [ -z "$gdriveRSID" ]; then
      gdrive mkdir $gdriveDir
      gdriveRSID=$(gdrive list --no-header | grep $gdriveDir | grep dir | awk '{ print $1}')
   fi
fi


# Local Backup Root Dir
mkdir -p $localPath

if [ "$multiDB" == "true" ]; then
    # Multiple database
    if [ "$become" == "true" ]; then
        # Multi DBS with root user
	echo "multidb root"
    else
        # Multi DBS with Multi users    
	echo "multi db multi user"
    fi
else   
    # Local Backup Dir
    mkdir -p $localPath$db1
    
    # Local Backup file
    backupFile=$localPath$db1"/"$db1.sql
	
    #Back up the Mysql Database
    mysqldump --user=$mysqlUser --password=$mysqlPassword $db1 > $backupFile
    echo "Local Backup Created"
    echo "Path : $backupFile"

    if [ "$backupMode" == "gdrive" ]; then
	#Check Gdrive backup folder exists on gdrive
        gdriveSID=$(gdrive list --no-header | grep $db1 | grep dir | awk '{ print $1}')
        if [ -z "$gdriveSID" ]; then
         gdrive mkdir --parent $gdriveRSID $db1
         gdriveSID=$(gdrive list --no-header | grep $db1 | grep dir | awk '{ print $1}')
        fi
    fi

    #Upload Mysql database
    gdrive upload --parent $gdriveSID $backupFile	

fi

