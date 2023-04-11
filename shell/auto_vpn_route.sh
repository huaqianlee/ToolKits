#!/bin/expect

detect_network(){   
    local timeout=1

    local target='www.baidu.com'

    local ret=`curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | tail -n1`

    if [ "x$ret" = "x200" ]; then
        return 1
    else
        return 0
    fi
}

vpn_route(){
    detect_network
    if [ $? -eq 0 ];then
        echo 'Automaticaly Re-route.'
        set timeout 30
        expect 'password:'
        send 'a\r'
        interact
    fi
}

start(){
    while(true)
        vpn_route
        sleep 1m        
}

start

exit 0