#!/bin/bash
# Author    : Lic. Guillermo Galeano Fernández
# Date      : 2024-09-05_224828
# License   : GPL v3.
# Filename  : bkp-schema-only.sh

# Objective : 
# Dump only the schema of a Postgresql databse from a client computer running Debian GNU/Linux OS.

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
DB="test"
USERNAME="postgres"

PGCLUSTER="12/$SERVER:$PORT"

DIR_OUT="/tmp/db/bkp"
DIR_LOG="/tmp/db/log"

OUTPUT_FILE_DB="$DIR_OUT/$DB-ddl-$SERVER-$(date +%F_%H%M%S).psql"

OUTPUT_LOG_FILE="$DIR_LOG/log-bkp-ddl-$DB-$SERVER-$(date +%F_%H%M%S).txt"

echo "$(date +%F_%H%M%S) - Started" | tee -a $OUTPUT_LOG_FILE

LOG="2>&1 | tee -a $OUTPUT_LOG_FILE"

BKP_COMMAND="pg_dump --cluster $PGCLUSTER --verbose --dbname=$DB --host=$SERVER --port=$PORT --username=$USERNAME --no-password --format=p --create --schema-only --file=$OUTPUT_FILE_DB $LOG"

echo "$(date +%F_%H%M%S) - Processing db: $DB" | tee -a $OUTPUT_LOG_FILE
echo "BKP_COMMAND= $BKP_COMMAND" | tee -a $OUTPUT_LOG_FILE

eval $BKP_COMMAND


echo "LOG: $OUTPUT_LOG_FILE" | tee -a $OUTPUT_LOG_FILE
echo "BKP: $OUTPUT_FILE_DB" | tee -a $OUTPUT_LOG_FILE
echo "$(date +%F_%H%M%S) - End" | tee -a $OUTPUT_LOG_FILE
