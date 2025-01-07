<h1 align="center">GLPI - IT Asset Management</h1>

<p align='justify'>

<a href="https://glpi-project.org">GLPI</a> - is an open source IT Asset Management, issue tracking system and service desk system. This software is written in PHP and distributed as open-source software under the GNU General Public License.

GLPI is a web-based application helping companies to manage their information system. The solution is able to build an inventory of all the organization's assets and to manage administrative and financial tasks. The system's functionalities help IT Administrators to create a database of technical resources, as well as a management and history of maintenances actions. Users can declare incidents or requests (based on asset or not) thanks to the Helpdesk feature.
</p>

- [GLPI Docker Image](** glpi-docker-image)
- [Install GLPI docker container](** install-glpi-docker-container)


##  Install GLPI docker container

** `git clone https://github.com/kochevrin/GLPI-alpine.git`

** Change variables in the `.env` to meet your requirements.
**  Note that the `.env` file should be in the same directory as `glpi-npm-letsencrypt-docker-compose.yml`.

**  Create networks for your services before deploying the configuration using the commands:
**  `docker network create glpi-network`
**  Make sure that NPM is running and the network npm-network exists. If not, you should start NPM with the network `npm-network`
**  `docker network create npm-network`

**  Deploy GLPI using Docker Compose:
**  `docker compose -f glpi-npm-letsencrypt-docker-compose.yml -p glpi up -d --build`
**  Remove GLPI using Docker Compose:
**  `docker compose -f glpi-npm-letsencrypt-docker-compose.yml -p glpi down --rmi all`

##  =========== After Installation Steps

**  docker exec -it glpi-glpi-1 sh

**  rm install/install.php

**  docker exec -it glpi-mariadb-1 bash

**  mariadb -uroot -p${MARIADB_ROOT_PASSWORD}

**  GRANT SELECT ON `mysql`.`time_zone_name` TO 'glpidbuser'@'%';

**  FLUSH PRIVILEGES;

**  \q

**  exit


**  docker exec -it glpi-glpi-1 sh

**  /usr/bin/php82 bin/console database:enable_timezones

## Backups

**  The `backups` container in the configuration is responsible for the following:

**  1. **Database Backup**: Creates compressed backups of the database.

**  Customizable backup path, filename pattern, and schedule through variables like `SOURCE_DB_PATH`, `DESTINATION_DB_PATH`, and `DAYS_TO_KEEP`.

**  2. **Volume Backup**: Archives and syncs the contents of Docker volumes using rsync.

**  Customizable volume names and backup paths through variables like `volumes` and `DESTINATION_VOLUMES_PATH`.

**  3. **Project Backup**: Archives and syncs the project files using rsync.

**  Customizable project path and backup path through variables like `PROJECT_DIR` and `DESTINATION_PROJECT_PATH`.

**  4. **Backup Pruning**: Periodically removes backups exceeding a specified age to manage storage.

**  Customizable pruning schedule and age threshold with `DAYS_TO_KEEP`.

**  By utilizing this container, consistent and automated backups of the essential components of your instance are ensured.

**  Moreover, efficient management of backup storage and tailored backup routines can be achieved through easy and flexible configuration using environment variables.

** Enjoy!