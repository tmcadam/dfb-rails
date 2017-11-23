#!/bin/bash

bash "/home/ukfit/.bashrc"

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BACKUP_FOLDER="/home/ukfit/db_backups/dfb/daily"
BACKUP_FILEPATH="$BACKUP_FOLDER/dfb-production-$(date -I).backup"

mkdir -p $BACKUP_FOLDER
export PGPASSWORD="$DFB_DB_PASS_PRODUCTION"
pg_dump --host localhost --port 5432 --username "$DFB_DB_USER_PRODUCTION" --no-password  --format custom --blobs --verbose --file "$BACKUP_FILEPATH" "$DFB_DB_PRODUCTION" >/dev/null 2>&1

echo "Daily backup ran: $(date -I)" >> "$BACKUP_FOLDER/backup.log"

#Delete daily backups older than 31 days
find "$BACKUP_FOLDER" -iname *.backup -type f -mtime +31 -exec rm -f {} \;
