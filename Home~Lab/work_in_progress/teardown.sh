#!/bin/bash




# disassociate IPs
FLOATIP=`neutron floatingip-list --format csv |awk -F, 'NR > 1 { print \$1}' |sed 's/^"\(.*\)"$/\1/'`
#PORTID=`neutron port-list --format csv |awk -F, 'NR > 1 { print \$1}' |sed 's/^"\(.*\)"$/\1/'`
neutron floatingip-disassociate $FLOATIP
neutron floatingip-delete $FLOATIP

#delete the instance
nova delete ebills-demo

#delete interface
neutron router-interface-delete router-gw subnet1
#delete internal network
neutron net-delete private
#delete router
neutron router-delete router-gw
