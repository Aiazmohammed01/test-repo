#!/bin/bash

# Variables for MariaDB
MARIADB_DB="test_db"
MARIADB_USER="db_user"  # Replace with your MariaDB username
MARIADB_PASS="your_password" 
MARIADB_BACKUP_FILE="~/test_db_backup.sql"  # Replace with your backup file path

# Set the MYSQL_PWD environment variable for password authentication
export MYSQL_PWD=$MARIADB_PASS

# Create the database (if it doesn't exist)
echo "Creating MariaDB database '$MARIADB_DB'..."
mysql -u $MARIADB_USER -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DB;"

# Restore the MariaDB database
echo "Restoring MariaDB database from backup..."
mysql -u $MARIADB_USER $MARIADB_DB < $MARIADB_BACKUP_FILE

# Check if the restore was successful
if [ $? -eq 0 ]; then
    echo "MariaDB restore successful"
else
    echo "MariaDB restore failed"
    exit 1
fi

# Unset the password variable for security reasons
unset MYSQL_PWD
