#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster} > /etc/ecs/ecs.config
yum install -y nfs-utils
echo "${nfs_fqdn}:/ /mnt/ nfs4  defaults  0   0" >> /etc/fstab
mount -a
service docker restart
