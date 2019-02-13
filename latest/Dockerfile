FROM gliderlabs/alpine:3.6
MAINTAINER linh@jmango360.com

ARG MY_USER="root"
ARG MY_PASS
ARG MY_HOST="localhost"
ARG MY_BACKUP_DIRECTORY="backup"
ARG MY_BACKUP_DB
ARG MY_STORED_DAY="7"


ENV MY_USER=${MY_USER}
ENV MY_PASS=${MY_PASS}
ENV MY_HOST=${MY_HOST}
ENV MY_BACKUP_DIRECTORY=${MY_BACKUP_DIRECTORY}
ENV MY_BACKUP_DB=${MY_BACKUP_DB}
ENV MY_STORED_DAY=${MY_STORED_DAY}

RUN apk add --no-cache mysql-client bash \
    && apk add --update coreutils \
    && rm -rf /var/cache/apk/*

ADD ./Backup_MySql_Database.sh /
RUN chmod +x /Backup_MySql_Database.sh

ENTRYPOINT ["/Backup_MySql_Database.sh"]

