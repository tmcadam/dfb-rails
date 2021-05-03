#!/bin/bash

source /src/swb_secrets

DFB_BACKUP_DIR="$BACKUP_DIR/dfb/monthly"
BACKUP_FILEPATH="$DFB_BACKUP_DIR/dfb.backup"
BACKUP_ZIP_FILEPATH="$DFB_BACKUP_DIR/dfb-$(date -I).zip"

mkdir -p $DFB_BACKUP_DIR
export PGPASSWORD="$POSTGRES_PASS"

pg_dump --host $POSTGRES_HOST --port $POSTGRES_PORT --username "$POSTGRES_USER" --no-password  --format custom --blobs --verbose --file "$BACKUP_FILEPATH" "$DFB_DB"

# zip up the images
cd "$DFB_DIR"
zip -r "$BACKUP_ZIP_FILEPATH" "biography_images"
zip -j "$BACKUP_ZIP_FILEPATH" $BACKUP_FILEPATH
rm -f $BACKUP_FILEPATH

# upload db backup and images to google drive using rclone
rclone copy "$BACKUP_ZIP_FILEPATH" "GDrive:SWB Backups/DFB"

# write to the log
echo "DFB monthly backup ran: $(date -I)" >> "$BACKUP_DIR/backup.log"
