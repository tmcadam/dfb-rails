#!/bin/bash

bash "/home/ukfit/.bashrc"

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_FOLDER="/home/ukfit/db_backups/dfb/monthly"
BACKUP_PROD_FILEPATH="$BACKUP_FOLDER/dfb-production-$(date -I).backup"
BACKUP_STAGING_FILEPATH="$BACKUP_FOLDER/dfb-staging-$(date -I).backup"
CURRENT_FILEPATH="$BACKUP_FOLDER/current.backup"

mkdir -p $BACKUP_FOLDER
export PGPASSWORD="$DFB_DB_PASS_PRODUCTION"
pg_dump --host localhost --port 5432 --username "$DFB_DB_USER_PRODUCTION" --no-password  --format custom --blobs --verbose --file "$BACKUP_PROD_FILEPATH" "$DFB_DB_PRODUCTION" >/dev/null 2>&1
export PGPASSWORD="$DFB_DB_PASS_STAGING"
pg_dump --host localhost --port 5432 --username "$DFB_DB_USER_STAGING" --no-password  --format custom --blobs --verbose --file "$BACKUP_STAGING_FILEPATH" "$DFB_DB_STAGING" >/dev/null 2>&1

cp $BACKUP_PROD_FILEPATH $CURRENT_FILEPATH
python2.7 "$PROJECT_DIR/sendmail.py" "$CURRENT_FILEPATH"
echo "Monthly backup ran: $(date -I)" >> "$BACKUP_FOLDER/backup.log"
