#!/bin/bash

# Variables for PostgreSQL
PG_DB="test_db"
PG_USER="postgres"
PG_PASSWORD="postgres"  # Replace with your PostgreSQL password
PG_BACKUP_DIR="~"
PG_BACKUP_FILE="$PG_BACKUP_DIR/test_db_backup.sql"

# Set the PGPASSWORD environment variable for password authentication
export PGPASSWORD=$PG_PASSWORD

# Backup PostgreSQL Database
echo "Backing up PostgreSQL database '$PG_DB'..."
pg_dump -U $PG_USER -F c -b -v -f $PG_BACKUP_FILE $PG_DB

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "PostgreSQL backup successful: $PG_BACKUP_FILE"
else
    echo "PostgreSQL backup failed"
    exit 1
fi

# Unset the password variable for security reasons
unset PGPASSWORD
