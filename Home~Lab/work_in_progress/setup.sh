#!/bin/bash
#
#used to setup demo environment for RHT SA Lab
#
#

#Create a router:
neutron router-create router-gw
#Configured that router to use your external network as the gateway:
neutron router-gateway-set router-gw public 
#Create internal network:
neutron net-create private
#Create subnet for internal network:
neutron subnet-create private 192.168.3.0/24 --gateway 192.168.3.1 --name subnet1
#Connected your private network to the router:
neutron router-interface-add router-gw subnet1

#boot RHEL7.1 image on m1.small flavor
nova boot --flavor m1.small --image 3c63b720-cabc-43e6-976b-54ce052bf7c1 --key_name evan-cloud-key ebills-demo

#floating ip connection setup
neutron floatingip-create public 
FLOATIP=`neutron floatingip-list --format csv |awk -F, 'NR > 1 { print \$1}' | sed 's/^"\(.*\)"$/\1/'`
INSTANCEIP="192.168.3.2"
PORTID=`neutron port-list --format csv |grep $INSTANCEIP |awk -F, '{ print \$1}' | sed 's/^"\(.*\)"$/\1/'`
neutron floatingip-associate $FLOATIP $PORTID
