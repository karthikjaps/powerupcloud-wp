#!/bin/bash

JENKINS_HOME=/opt/jenkins_home
config="[default]\nregion = ${region}"
echo -e "$config" > /opt/jenkins_home/aws/config
credentials="[default]\naws_access_key_id = ${aws_access_key}\naws_secret_access_key = ${aws_secret_key}"
echo -e "$credentials" > /opt/jenkins_home/aws/credentials
# Create and set correct permissions for Jenkins mount directory
sudo mkdir -p $JENKINS_HOME
sudo chmod -R 777 $JENKINS_HOME
# Start Jenkins
docker run -u root -id --name jenkins3 -p 80:8080 -p 50000:50000 -v $JENKINS_HOME:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker jamsheer/awscli-jenkins:latest