#!/bin/bash
sudo yum update
yum install -y nfs-utils
sudo yum install -y ruby
sudo yum install -y wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
echo "${nfs_fqdn}:/ /mnt/ nfs4  defaults  0   0" >> /etc/fstab
mount -a
service docker restart
docker pull jamsheer/wordpress:latest
docker run -id --name wordpress -p 80:80 --env WORDPRESS_DB_USER=${rds_username} --env WORDPRESS_DB_PASSWORD=${rds_password} --env WORDPRESS_DB_NAME=${rds_db_name} --env WORDPRESS_DB_HOST=${rds_db_host}  -v /mnt/wordpress:/var/www/html/ jamsheer/wordpress:latest