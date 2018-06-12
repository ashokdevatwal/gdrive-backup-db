#!/bin/bash

# Load Settings file 
. .settings


# Local Backup Root Dir
#######################
mkdir -p $localPath


# Gdrive Backup Root Dir
#######################
if [ "$backupMode" == "gdrive" ]; then		
   #Check Gdrive backup Root folder exists on gdrive
   gdriveRSID=$(gdrive list --no-header | grep $gdriveDir | grep dir | awk '{ print $1}')
   if [ -z "$gdriveRSID" ]; then
      gdrive mkdir $gdriveDir
      gdriveRSID=$(gdrive list --no-header | grep $gdriveDir | grep dir | awk '{ print $1}')
   fi
fi


#  BASE FUNCTIONS
#########################

function databaseBackup(){
  database=$1
  # Local Backup Dir
  mkdir -p $localPath$database
    
  # Local Backup file
  backupFile=$localPath$database"/"$database.sql
	
  #Back up the Mysql Database
  mysqldump --user=$mysqlUser --password=$mysqlPassword $database > $backupFile
  echo "Local Backup Created"
  echo "Path : $backupFile"

  if [ "$backupMode" == "gdrive" ]; then
    #Check Gdrive backup folder exists on gdrive
    gdriveSID=$(gdrive list --no-header | grep $database | grep dir | awk '{ print $1}')
    if [ -z "$gdriveSID" ]; then
      gdrive mkdir --parent $gdriveRSID $database
      gdriveSID=$(gdrive list --no-header | grep $database | grep dir | awk '{ print $1}')
      fi
    #Upload Mysql database
    gdrive upload --parent $gdriveSID $backupFile
  fi

  

}

# END databaseBackup
#########################



# Start Backup
#####################

if [ "$multiDB" == "true" ]; then
    # Multiple database
    if [ "$become" == "true" ]; then
        # Multi DBS with root user
	echo "Multi DBS"
	for database in "${databaseName[@]}"; do
           databaseBackup $database	
	done 
    else
        # Multi DBS with Multi users    
	for database in "${databaseName[@]}"; do
           i=0
	   mysqlUser=${dbusers[$i]}
	   dbpasswords=${dbusers[$i]}
	   databaseBackup $database	
	done 
    fi
else   
    databaseBackup $databaseName	
fi

