#!/bin/bash

# Variables for PostgreSQL
PG_DB="test_db"
PG_USER="postgres"
PG_PASSWORD="postgres"  
PG_BACKUP_FILE="~/test_db_backup.sql"  

# Set the PGPASSWORD environment variable for password authentication
export PGPASSWORD=$PG_PASSWORD

# Create the database (if it doesn't exist)
echo "Creating PostgreSQL database '$PG_DB'..."
psql -U $PG_USER -c "CREATE DATABASE IF NOT EXISTS $PG_DB;"

# Restore the PostgreSQL database
echo "Restoring PostgreSQL database from backup..."
pg_restore -U $PG_USER -d $PG_DB -v $PG_BACKUP_FILE

# Check if the restore was successful
if [ $? -eq 0 ]; then
    echo "PostgreSQL restore successful"
else
    echo "PostgreSQL restore failed"
    exit 1
fi

# Unset the password variable for security reasons
unset PGPASSWORD
