#!/bin/bash
yum install -y nfs-utils
echo "${nfs_fqdn}:/ /mnt/ nfs4  defaults  0   0" >> /etc/fstab
mount -a
service docker restart
docker pull jamsheer/wordpress:latest
docker run -id --name wordpress -p 80:80 --env WORDPRESS_DB_USER=${rds_username} --env WORDPRESS_DB_PASSWORD=${rds_password} --env WORDPRESS_DB_NAME=${rds_db_name} --env WORDPRESS_DB_HOST=${rds_db_host}  -v /mnt/wordpress:/var/www/html/ jamsheer/wordpress:latest