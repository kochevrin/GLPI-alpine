#!/bin/sh

# Variables
PROJECT_DIR="/home/user/glpi"
SOURCE_DB_PATH="/var/lib/docker/volumes/glpi_mariadb-backups/_data/"
DESTINATION_BACKUP="/srv/backups/glpi"
DESTINATION_DB_PATH="${DESTINATION_BACKUP}/mariadb-backups"
DESTINATION_PROJECT_PATH="${DESTINATION_BACKUP}/project"
DESTINATION_VOLUMES_PATH="${DESTINATION_BACKUP}/volumes"
DAYS_TO_KEEP=7
DATE=$(date "+%Y-%m-%d_%H-%M")

# Create destination directories if they do not exist
mkdir -p $DESTINATION_DB_PATH
mkdir -p $DESTINATION_PROJECT_PATH
mkdir -p $DESTINATION_VOLUMES_PATH

# Delete old backups
find $DESTINATION_BACKUP -type f -mtime +$DAYS_TO_KEEP -exec rm -f {} \;

# Archive and sync volumes
volumes=$(docker volume ls -q | grep glpi)
for volume in $volumes; do
    path=$(docker volume inspect --format '{{ .Mountpoint }}' $volume)
    tar -czf /tmp/${volume}_${DATE}.tar.gz -C $path .
    rsync -az --inplace /tmp/${volume}_${DATE}.tar.gz $DESTINATION_VOLUMES_PATH/${volume}_${DATE}.tar.gz
    rm /tmp/${volume}_${DATE}.tar.gz
done

# Sync database backups
rsync -az $SOURCE_DB_PATH $DESTINATION_DB_PATH

# Archive and sync project
tar -czf /tmp/project_${DATE}.tar.gz -C $PROJECT_DIR .
rsync -az --inplace /tmp/project_${DATE}.tar.gz $DESTINATION_PROJECT_PATH/project_${DATE}.tar.gz
rm /tmp/project_${DATE}.tar.gz
