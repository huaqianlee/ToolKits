#!/bin/sh
##
# @file tomato.sh
# @brief 
# @author Andy Lee <huaqianlee@gmail.com> 
# @version 
# @date 2023-04-09
#
# @copyright Copyright (c) 2023
#

# locate $1
# dpkg --list | grep $1
# whereis $1 | grep $1

install_tool () {
    dpkg -s $1 | grep "Status: install ok installed" >> /dev/null
    if [ $? -eq 0 ];then
        echo "$1 has already been installed."
    else
        sudo apt install $1
    fi
}

kill_app () {
    app_id=`ps -ef | grep $1 | grep -v grep | awk '{print $2}'`
    echo ${app_id}
    kill -9 ${app_id}
}

run () {
    #tick_time=30
    while(true)
    do
        echo 'env DISPLAY=:0 feh -F /home/lee/bin/pic/MyDesktop.jpg' | at now+30 minutes
        sleep 30m
        sleep 5m
        kill_app feh
    done
}

install_tool feh
install_tool at && run
exit 0
