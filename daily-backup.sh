#!/bin/bash

source /src/swb_secrets

DFB_BACKUP_DIR="$BACKUP_DIR/dfb/daily"
BACKUP_FILEPATH="$DFB_BACKUP_DIR/dfb-$(date -I).backup"

mkdir -p $DFB_BACKUP_DIR
export PGPASSWORD="$POSTGRES_PASS"

pg_dump --host $POSTGRES_HOST --port $POSTGRES_PORT --username "$POSTGRES_USER" --no-password  --format custom --blobs --verbose --file "$BACKUP_FILEPATH" "$DFB_DB"

find "$DFB_BACKUP_DIR" -iname *.backup -type f -mtime +31 -exec rm -f {} \;

# write to the log
echo "DFB daily backup ran: $(date -I)" >> "$BACKUP_DIR/backup.log"

