#!/bin/bash

JENKINS_HOME=/opt/jenkins_home
if [ ! -e /opt/jenkins_home/aws/config  ]; then
    config="[default]
            region = ${region}"
    echo "$config" | tee /opt/jenkins_home/aws/config
fi
if [ ! -e /opt/jenkins_home/aws/credentials  ]; then
    credentials="[default]
        aws_access_key_id = ${aws_access_key}
        aws_secret_access_key = ${aws_secret_key}"
    echo "$credentials" | tee /opt/jenkins_home/aws/credentials
fi
# Create and set correct permissions for Jenkins mount directory
sudo mkdir -p $JENKINS_HOME
sudo chmod -R 777 $JENKINS_HOME
# Start Jenkins
docker run -u root -id --name jenkins3 -p 80:8080 -p 50000:50000 -v $JENKINS_HOME:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker jamsheer/awscli-jenkins:latest