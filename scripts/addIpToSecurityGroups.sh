#!/bin/sh
exec scala "$0" "$@"
!#

import sys.process._

case class SG(name:String, sg:String)
val devShared=SG("Mobsters Dev Shared", "sg-005ee565")
val prodGS=SG("Mobsters Prod Game Server","sg-3e823d5b")
val prodMySQL=SG("Mobsters Prod MySQL","sg-2f7ac54a")
val prodRabbit=SG("Mobsters Prod RabbitMQ","sg-a579c6c0")
val jenkins=SG("Jenkins","sg-c81a7dad")
val influx=SG("InfluxDB","sg-c1a4f1a4")

val sshGroups=List(devShared,prodGS,prodMySQL,prodRabbit,jenkins,influx)
val rabbitGroups=List(devShared,prodRabbit)
val mysqlGroups=List(devShared,prodMySQL)
val tomcatGroups=List(jenkins)

val cIp:String = "dig +short myip.opendns.com @resolver1.opendns.com" !!
val currentIp = cIp.trim

println("Adding current IP: "+currentIp+"/32")

def addToSecurityGroup(port:Int, sg:SG)={
	println(s"Enabling port: $port to SG: ${sg.name}");
	val cidr = raw"$currentIp/32"
	val cmd = raw"""aws ec2 authorize-security-group-ingress --group-id ${sg.sg} --port $port --cidr ${cidr} --protocol tcp""";
//	println(cmd)
	val result = cmd !;
	if(result != 0){
		println(s"Error enabling port: $port for SG: ${sg.name}")
	}
	println("")
}

sshGroups.foreach( sg => addToSecurityGroup(22, sg))
rabbitGroups.foreach( sg => addToSecurityGroup(15672, sg))
mysqlGroups.foreach( sg => addToSecurityGroup(3306, sg))
tomcatGroups.foreach( sg => addToSecurityGroup(8080, sg))


