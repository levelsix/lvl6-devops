#!/bin/bash

echo Backing up Jenkins

DATE=`date +%Y-%m-%d-%H-%M-%S`
backupDir=/opt/jenkinsBackups
backupName=$backupDir/jenkins-backup-$DATE.7z
jenkinsDir=/var/lib/jenkins
s3Bucket=lvl6-build-backups

7z a "$backupName" "$jenkinsDir"


echo Removing old backups

find $backupDir -iname "*.7z" -type f -mtime +60 -exec rm {} \;


echo Syncing to S3

aws s3 sync s3://$s3bucket/jenkins/ $backupDir/ --acl private --delete



