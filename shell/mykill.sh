#!/bin/sh
##
# @file mykill.sh
# @brief kill progress fuzzily 
# @author Andy Lee <huaqianlee@gmail.com> 
# @version 0.1 
# @date 2023-04-09
#
# @copyright Copyright (c) 2023
#

pid_process=`ps -ef | grep $1 | grep -v grep | awk '{print $2}'`
kill -9 ${pid_process}
