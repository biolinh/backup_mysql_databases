#!/bin/bash
# Shell script to backup MySql database 
# To backup Nysql databases file to /backup dir and later pick up by your 
# script. You can skip few databases from backup too.
# --------------------------------------------------------------------
# This is a free shell script under GNU GPL version 2.0 or above
# Copyright (C) 2004, 2005 nixCraft project
# Feedback/comment/suggestions : http://cyberciti.biz/fb/
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------

MyUSER="${MY_USER}"     # USERNAME
MyPASS="${MY_PASS}"       # PASSWORD 
MyHOST="${MY_HOST}"          # Hostname

MySTOREDAY="${MY_STORED_DAY}" # number of day to skip before remove.

# Linux bin paths, change this if it can not be autodetected via which command
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"
# CHOWN="$(which chown)"
# CHMOD="$(which chmod)"


# Backup Dest directory, change this if you have someother location
DEST="${MY_BACKUP_DIRECTORY}"

# Get hostname
HOST="$(hostname)"

# Get data in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y")"

OBD="$(date -d "$MySTOREDAY day ago" +"%d-%m-%Y")"
  
# Main directory where backup will be stored
MBD="$DEST/$NOW"

# Directory will be removed
RBD="$DEST/$OBD"

# File to store current backup file
FILE=""
# Store list of databases 
DBS="${MY_BACKUP_DB}"

# DO NOT BACKUP these databases
IGGY="information_schema performance_schema sys mysql"

[ ! -d $MBD ] && mkdir -p $MBD || :

# Only root can access it!
# $CHOWN 0.0 -R $DEST
# $CHMOD 0600 $DEST

# Get all database list first
#DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"

for db in $DBS
do
    skipdb=-1
    if [ "$IGGY" != "" ];
    then
	for i in $IGGY
	do
	    [ "$db" == "$i" ] && skipdb=1 || :
	done
    fi
    
    if [ "$skipdb" == "-1" ] ; then
	FILE="$MBD/$db.$HOST.$NOW.gz"
	echo "Backup database $db"
	# do all inone job in pipe,
	# connect to mysql using mysqldump for select mysql database
	# and pipe it out to gz file in backup dir :)
        $MYSQLDUMP -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE
    echo "$db is backuped into: $FILE"    
    fi

done


#remove backupfile older than x days
echo "remove backupfile older than $MySTOREDAY"
echo "the day to remove  is $OBD"
mv $RBD /tmp && rm -rf /tmp/$RBD
