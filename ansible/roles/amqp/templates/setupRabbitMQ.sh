#!/bin/bash

#create vhosts

echo creating vhost {{rabbit_vhost}}
rabbitmqctl add_vhost {{rabbit_vhost}}


#create users

rabbitmqctl add_user {{rabbit_client_user}} {{rabbit_client_pass}}
rabbitmqctl add_user {{rabbit_server_user}} {{rabbit_server_pass}}
rabbitmqctl add_user {{rabbit_api_user}} {{rabbit_api_pass}}

#set permissions

rabbitmqctl set_permissions -p {{rabbit_vhost}} {{rabbit_client_user}} ".*" ".*" ".*"
rabbitmqctl set_permissions -p {{rabbit_vhost}} {{rabbit_server_user}} ".*" ".*" ".*"
rabbitmqctl set_permissions -p {{rabbit_vhost}} {{rabbit_api_user}} "" "" ".*"

#set tags
rabbitmqctl set_user_tags {{rabbit_api_user}} management monitoring
