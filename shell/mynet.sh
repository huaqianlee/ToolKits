#!/bin/bash
##
# @file mynet.sh
# @brief 
# @author 
# @version 
# @date 2023-04-09
#
# @copyright Copyright (c) 2023
#

# Ubuntu 16.04
addsomcroute()
{
    MyGateWay=`/sbin/ifconfig tun0 | grep "inet " | awk '{ print $2}' | sed -e "s/addr://"`
    echo "My GateWay is $MyGateWay"
    if [ -n "$MyGateWay" ]; then 

        echo "sudo route add -net 10.128.0.0/9 gw $MyGateWay"
		
		
        sudo route add -net 10.128.0.0/9 gw $MyGateWay

        echo "sudo route del -net 0.0.0.0/1 gw $MyGateWay"
        sudo route del -net 0.0.0.0/1 gw $MyGateWay

        echo "sudo route del -net 128.0.0.0/1 gw $MyGateWay"
        sudo route del -net 128.0.0.0/1 gw $MyGateWay
    else
        echo "tun0 inet addr is null, exit "
    fi
}

# Ubuntu 18.04
function addf5route()
{
    MyGateWay=`ifconfig tun0 | grep "inet " | awk '{ print $2}'`
    echo "My GateWay is $MyIP"
    if [ -n "$MyGateWay" ]; then
        echo "sudo route add -net 10.128.0.0/9 gw $MyGateWay"
        sudo route add -net 10.128.0.0/9 gw $MyGateWay
        echo "sudo route del -net 0.0.0.0/1 gw $MyGateWay"
        sudo route del -net 0.0.0.0/1 gw $MyGateWay
        echo "sudo route del -net 128.0.0.0/1 gw $MyGateWay"
        sudo route del -net 128.0.0.0/1 gw $MyGateWay
    else
        echo "tun0 inet addr is null, exit "
    fi
}


start()
{
	os_strs=$(cat /etc/os-release)
	os_verison="18.04"
	for str in $os_strs
	do
		if [ $str = 'VERSION_ID="18.04"' ];then
				#echo "The os version is 18.04." 
				os_verison="18.04"
		elif [ $str = 'VERSION_ID="16.04"' ];then
				#echo "The os version is 16.04." 
				os_verison="16.04"
		fi
	done	

	while true
	do
		ping -c 8 www.baidu.com
		ret=$?

		if [ $ret != 0 ]; then
			echo "net wrong, trigger vpn route !"
			if [ $os_verison = "18.04" ];then
				addf5route
			elif [ $os_verison = "16.04" ];then 
				addsomcroute
			fi			
		else
			echo "net ok, skip ..."
		fi
		sleep 5m;
	done
}

start
