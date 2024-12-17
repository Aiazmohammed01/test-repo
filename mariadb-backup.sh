#!/bin/bash

# Variables for MariaDB
MARIADB_DB="test_db"
MARIADB_USER="db_user"  # Replace with your MariaDB username
MARIADB_PASS="your_password"  # Replace with your MariaDB password
MARIADB_BACKUP_DIR="~"  # Replace with your backup directory
MARIADB_BACKUP_FILE="$MARIADB_BACKUP_DIR/test_db_backup.sql"

# Set the MYSQL_PWD environment variable for password authentication
export MYSQL_PWD=$MARIADB_PASS

# Backup MariaDB Database
echo "Backing up MariaDB database '$MARIADB_DB'..."
mysqldump -u $MARIADB_USER $MARIADB_DB > $MARIADB_BACKUP_FILE

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "MariaDB backup successful: $MARIADB_BACKUP_FILE"
else
    echo "MariaDB backup failed"
    exit 1
fi

# Unset the password variable for security reasons
unset MYSQL_PWD
