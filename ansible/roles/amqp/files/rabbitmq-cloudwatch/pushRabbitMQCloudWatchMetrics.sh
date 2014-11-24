#!/bin/bash

timestamp=$(date -u +%Y-%m-%dT%H:%M:%S.000Z)


EC2_INSTANCE_ID=$(ec2metadata --instance-id)
EC2_HOSTNAME=$(ec2metadata --public-hostname)
HOSTNAME=$(hostname)
AZ=$(ec2metadata --availability-zone)
echo "pushing --metric $1 --value $2 --namespace $3 --dimensions instanceId=$EC2_INSTANCE_ID, ec2_hostname=$EC2_HOSTNAME, az=$AZ, hostname=$HOSTNAME"
aws cloudwatch put-metric-data --metric-name $1 --namespace "$3" --value $2 --timestamp $timestamp --dimensions "instanceId=$EC2_INSTANCE_ID,ec2_hostname=$EC2_HOSTNAME,az=$AZ,hostname=$HOSTNAME"
