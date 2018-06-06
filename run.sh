#!/bin/bash

# Load Settings file 
. .settings

# local backup path
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
    # Single database
    echo "Mode : Single Database"
    #Back up the Mysql Database
    mysqldump --user=$mysqlUser --password=$mysqlPassword $db1 > $localPath$db1.sql
    echo "Local Backup Created"
    echo "Path : $localPath$db1.sql"
fi

