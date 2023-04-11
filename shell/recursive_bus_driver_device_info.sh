#!/bin/bash
##
# @file recursive_bus_driver_device_info.sh
# @brief 
# @author Andy Lee <huaqianlee@gmail.com> 
# @version 0.1
# @date 2023-04-09
#
# @copyright Copyright (c) 2023
#

# Populate block devices
for i in /sys/block/*/dev /sys/block/*/*/dev
do
	if [ -f $i ]
	then
	MAJOR=$(sed 's/:.*//' < $i)
	MINOR=$(sed 's/.*://' < $i)
	DEVNAME=$(echo $i | sed -e 's@/dev@@' -e 's@.*/@@')
	echo /dev/$DEVNAME b $MAJOR $MINOR
	#mknod /dev/$DEVNAME b $MAJOR $MINOR
	fi
done

# Populate char devices
for i in /sys/bus/*/devices/*/dev /sys/class/*/*/dev
	do
	if [ -f $i ]
	then
	MAJOR=$(sed 's/:.*//' < $i)
	MINOR=$(sed 's/.*://' < $i)
	DEVNAME=$(echo $i | sed -e 's@/dev@@' -e 's@.*/@@')
	echo /dev/$DEVNAME c $MAJOR $MINOR
	#mknod /dev/$DEVNAME c $MAJOR $MINOR
	fi
done
