#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
  # Variables
  ECS_CLUSTER_NAME=${ECS_CLUSTER_NAME}
  LAUNCHTIME=${LAUNCHTIME}
  # Install libs
  yum -y update
  yum install -y yum-utils amazon-ssm-agent
  
  systemctl status amazon-ssm-agent
  
  echo "LAUNCHTIME=$LAUNCHTIME" >> /etc/ecs/ecs.config
  echo "ECS_CLUSTER=$ECS_CLUSTER_NAME" >> /etc/ecs/ecs.config