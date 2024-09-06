#!/bin/bash

# Author    : Lic. Guillermo Galeano Fernández
# Date      : 2024-09-05_224828
# License   : GPL v3.
# Filename  : restore-bkp.sh
# Objective : 
# Restore a dump of a Postgresql database from a client computer running Debian GNU/Linux OS.
# Encoding used by default: en_US.UTF8

# Syntax:
# $ restore-bkp.sh DB BKP_FILE

# DB = name of the db to be created.
# BKP_FILE = fullpath and name of the file to be restored.

# Requires the existence of the directories:
# DIR_OUT="/tmp/db/bkp"
# DIR_LOG="/tmp/db/log"

# Requires the existence of the file:
# ~/.pgpass 
# with chmod 0600

# Example:
# $ cat ~/.pgpass
# # hostname:port:database:username:password 
# localhost:5432:*:postgres:my-super-secret-Password
# 127.0.0.1:5432:*:postgres:my-super-secret-Password


# pgdump format = custom without compression


# Tested with:
#$ dpkg -l | grep -E '\ bash\ \ |base\-files|postgresql-client' 
#ii  base-files                            12.4+deb12u6                        amd64        Debian base system miscellaneous files
#ii  bash                                  5.2.15-2+b7                         amd64        GNU Bourne Again SHell
#ii  postgresql-client-12                  12.19-1.pgdg120+1                   amd64        front-end programs for PostgreSQL 12
#ii  postgresql-client-common              261.pgdg120+1                       all          manager for multiple PostgreSQL client versions

DB="$1"
BKP_FILE="$2"


SERVER="localhost"
PORT="5432"
USERNAME="postgres"

PGCLUSTER="12/$SERVER:$PORT"

DIR_LOG="/tmp/db/log"
OUTPUT_LOG_FILE="$DIR_LOG/log-restore-$DB-$SERVER-$(date +%F_%H%M%S).txt"

LOG="2>&1 | tee -a $OUTPUT_LOG_FILE"

echo "$(date +%F_%H%M%S) - Started" | tee -a $OUTPUT_LOG_FILE

# Create DB:
STEP1="createdb --cluster $PGCLUSTER --host=$SERVER --port=$PORT --username=$USERNAME --no-password --echo --encoding='UTF8' --lc-collate='en_US.UTF8' --lc-ctype='en_US.UTF8' --owner=$USERNAME --template=template0 $DB $LOG"
echo "STEP1= $STEP1" | tee -a $OUTPUT_LOG_FILE

# list restore
STEP2="pg_restore --cluster $PGCLUSTER --list --dbname=$DB --host=$SERVER --port=$PORT --username=$USERNAME --no-password --verbose --format=c $BKP_FILE | head -n 12 $LOG"
echo "STEP2= $STEP2" | tee -a $OUTPUT_LOG_FILE

# restore
STEP3="pg_restore --cluster $PGCLUSTER --verbose --dbname=$DB --host=$SERVER --port=$PORT --username=$USERNAME --no-password --format=c $BKP_FILE $LOG"
echo "STEP3= $STEP3" | tee -a $OUTPUT_LOG_FILE

eval $STEP1 && eval $STEP2 && eval $STEP3

echo "SERVER= $SERVER" | tee -a $OUTPUT_LOG_FILE
echo "PORT= $PORT" | tee -a $OUTPUT_LOG_FILE

echo "LOG: $OUTPUT_LOG_FILE" | tee -a $OUTPUT_LOG_FILE
echo "BKP_FILE= $BKP_FILE" | tee -a $OUTPUT_LOG_FILE
echo "DB= $DB" | tee -a $OUTPUT_LOG_FILE

echo "$(date +%F_%H%M%S) - End" | tee -a $OUTPUT_LOG_FILE

