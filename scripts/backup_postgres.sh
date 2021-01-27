#!/bin/bash

## Script que se ejecuta de manera cíclica con cron que genera un archivo de 
## backup de una base de datos postgres cuyo nombre se basa en la fecha y hora 
## actual del sistema y que luego se comprime con formato bzip y posteriormente 
## este archivo se sube a un bucket de  Amazon Web Services S3 para su almacenamiento.
## 
## Para que este script funcione es necesario que se encuentren instaladas
## las siguientes herramientas:
##   - postgresql-client mejor si es en su ultima versión estable
##   - AWS CLI Versión 2
##   - bzip2
##
## Este script funciona en conjunto con la configuración del archivo ~/.pgpass
## 
## Enlaces guía:
## https://www.postgresql.org/docs/current/libpq-pgpass.html
## http://www.londatiga.net/it/database-it/how-to-use-postgresql-pgdump-in-crontab-without-password/
## https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
## https://aws.amazon.com/es/getting-started/hands-on/backup-to-s3-cli/
## https://medium.com/@nimeshcool77/how-to-upload-the-file-on-s3-bucket-via-terminal-1ce6343ac779
##

archivo=$(date +"%Y%m%d_%H%M")

# user
user=<nombre del usuario>
# host
host=<nombre del host>
# port
port=<Puerto>
# db
db=<Nombre de la base de datos>

# s3 bucket name
bucket=<Nombre del bucket de AWS S3>

# Se utiliza el parámetro -w para que no se solicite una contraseña y que se
# obtenga del archivo ~/.pgpass
/usr/bin/pg_dump -U "$user" -w -h "$host" -p "$port" -d "$db" | bzip2 > "$archivo".bz2

/usr/local/bin/aws s3 cp "$archivo".bz2 s3://"$bucket" > /dev/null

/usr/bin/rm "$archivo".bz2