#!/bin/bash

# Author    : Lic. Guillermo Galeano Fernández
# Date      : 2024-09-05_224828
# License   : GPL v3.
# Filename  : bkp-roles.sh

# Objective : 
# Dump global objects of a Postgresql host from a client computer running Debian GNU/Linux OS.

# Requires a superuser account: postgres

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


# Tested with:
#$ dpkg -l | grep -E '\ bash\ \ |base\-files|postgresql-client' 
#ii  base-files                            12.4+deb12u6                        amd64        Debian base system miscellaneous files
#ii  bash                                  5.2.15-2+b7                         amd64        GNU Bourne Again SHell
#ii  postgresql-client-12                  12.19-1.pgdg120+1                   amd64        front-end programs for PostgreSQL 12
#ii  postgresql-client-common              261.pgdg120+1                       all          manager for multiple PostgreSQL client versions


SERVER="localhost"
PORT="5432"
# Required a superuser account:
USERNAME="postgres"

# Usefull only with supported versions of Postgresql in Debian
#PGCLUSTER=" --cluster 12/$SERVER:$PORT"
PGCLUSTER=""

# Without / at the end!
DIR_BIN="/usr/lib/postgresql/12/bin"
DIR_OUT="/tmp/db/bkp"
DIR_LOG="/tmp/db/log"

OUTPUT_FILE="$DIR_OUT/db-global-$SERVER-$(date +%F_%H%M%S).psql"
OUTPUT_LOG_FILE="$DIR_LOG/log-bkp-roles-$SERVER-$(date +%F_%H%M%S).txt"

echo "$(date +%F_%H%M%S) - Started" | tee -a $OUTPUT_LOG_FILE

LOG="2>&1 | tee -a $OUTPUT_LOG_FILE"

BKP_COMMAND="$DIR_BIN/pg_dumpall $PGCLUSTER --database=postgres --host=$SERVER --port=$PORT --username=$USERNAME --no-password --globals-only --file=$OUTPUT_FILE $LOG"
echo "BKP_COMMAND= $BKP_COMMAND" | tee -a $OUTPUT_LOG_FILE

eval $BKP_COMMAND

HEADER_DUMP="tail -n 15 $OUTPUT_FILE"


echo "HEADER_DUMP= $HEADER_DUMP" | tee -a $OUTPUT_LOG_FILE

eval $HEADER_DUMP

echo "LOG: $OUTPUT_LOG_FILE" | tee -a $OUTPUT_LOG_FILE
echo "BKP: $OUTPUT_FILE" | tee -a $OUTPUT_LOG_FILE

echo "$(date +%F_%H%M%S) - End" | tee -a $OUTPUT_LOG_FILE
