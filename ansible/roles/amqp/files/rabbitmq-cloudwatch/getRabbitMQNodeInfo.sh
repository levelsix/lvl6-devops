#!/bin/bash

set -e

RABBITURL=http://rabbitinstance.yourserver.com:55672/api
RABBITUSER=yourrabbituser
RABBITPASS=somepassword
RABBITNODE="yournode@yourhost"

#create this file and give it read/write permissions
RABBITINFOFILE="/tmp/rabbitnodeinfo.json"
RABBITSTATS="fd_used,fd_total,sockets_used,sockets_total,mem_alarm,disk_free_alarm,mem_used,mem_limit,disk_free_limit,disk_free,proc_used,proc_total"

function usage { 
	echo "Usage: $0 -r RABBITURL  -u USER -p PASS -n RABBITNODE [-f INFOFILE] [-s RABBITSTATS]"
	 exit 1
}


NUMARGS=$#
#echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
  usage
fi

 
while getopts "r:u:p:n:fsh" opt; do
  case $opt in
    r)
		RABBITURL=$OPTARG
		#echo "-r used $OPTARG"
      ;;
    u)
		RABBITUSER=$OPTARG
      ;;
    p)
		RABBITPASS=$OPTARG
      ;;
    n)
		RABBITNODE=$OPTARG
      ;;
    f)
		RABBITINFOFILE=$OPTARG
      ;;
    s)
		RABBITSTATS=$OPTARG
      ;;
    h)
		usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." 
      usage
      ;;
  esac
done



cloudWatchNameSpace="RabbitMQ"

sendToCloudWatch() {
	while read data; do
		#echo "Args: $data" 
		./pushRabbitMQCloudWatchMetrics.sh $data $cloudWatchNameSpace
	done
}


#echo Connection to $RABBITUSER:$RABBITPASS $RABBITURL/nodes/$RABBITNODE


#if rabbit info doesn't exist get it from api
if [ ! -f $RABBITINFOFILE ]
then
	curl -s -u $RABBITUSER:$RABBITPASS $RABBITURL/nodes/$RABBITNODE | python -mjson.tool > $RABBITINFOFILE
fi
#if rabbit info hasn't been updated in the last minute refresh it from api
if test `find "$RABBITINFOFILE" -mmin +1`
then
	curl -s -u $RABBITUSER:$RABBITPASS $RABBITURL/nodes/$RABBITNODE | python -mjson.tool > $RABBITINFOFILE
fi
python ./getJsonProperty.py $RABBITINFOFILE $RABBITSTATS | sendToCloudWatch
exit 0
