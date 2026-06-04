#!/bin/bash
# Daily MySQL backup script for score-predictor project
# Saves dumps to ./mysqlbackup with timestamped filenames

# Ensure backup directory exists
BACKUP_DIR="$(dirname "$0")/mysqlbackup"
mkdir -p "$BACKUP_DIR"

# Timestamp for the dump file
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# MySQL credentials are read from the running container's environment variables
# Using docker exec to run mysqldump inside the sp_mysql container
docker exec sp_mysql mysqldump \
  -u"${MYSQL_USER:-sp_user}" \
  -p"${MYSQL_PASSWORD:-sp_password}" \
  "${MYSQL_DATABASE:-sp_db}" > "$BACKUP_DIR/backup_${TIMESTAMP}.sql"

# Optional: remove backups older than 7 days
find "$BACKUP_DIR" -type f -name "backup_*.sql" -mtime +7 -delete
