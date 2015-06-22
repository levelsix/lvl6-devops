#!/bin/bash

echo Backing up Jenkins

DATE=`date +%Y-%m-%d-%H-%M-%S`
backupDir=/opt/jenkinsBackups
backupName=$backupDir/jenkins-backup-$DATE.7z
jenkinsDir=/var/lib/jenkins
s3Bucket=lvl6-build-backups

7z a "$backupName" "$jenkinsDir" -xr!target -xr!.git -xr!.m2 -xr!*.jar -xr!*.war


echo Removing old backups

find $backupDir -iname "*.7z" -type f -mtime +60 -exec rm {} \;


echo Syncing to S3 with command: 
echo aws s3 sync $backupDir/ s3://$s3Bucket/jenkins/ --acl private --delete --region us-west-2

aws s3 sync $backupDir/ s3://$s3Bucket/jenkins/ --acl private --delete --region us-west-2


