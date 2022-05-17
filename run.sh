#!/bin/bash

if [ "$1" = "build" ]; then
    # build
    docker-compose build --no-cache
elif [ "$1" = "start" ]; then
    # start
    docker-compose up -d
elif [ "$1" = "stop" ]; then
    # stop
    docker-compose down
elif [ "$1" = "restart" ]; then
    # restart
    docker exec -it cushib-dev-web-server bash -c "/etc/init.d/shibd restart"
elif [ "$1" = "status" ]; then
    # status
    docker exec -it cushib-dev-web-server bash -c "/etc/init.d/shibd status"
elif [ "$1" = "bash" ]; then
    # bash
    docker exec -it cushib-dev-web-server bash
elif [ "$1" = "logs" ]; then
    # logs
    docker logs -f cushib-dev-web-server
elif [ "$1" = "test" ]; then
    # test
    docker exec -it cushib-dev-web-server bash -c "LD_LIBRARY_PATH=/opt/shibboleth/lib64 /sbin/shibd -t"
else
    # default
    echo "Usage: $0 {build|start|stop|restart|status|bash|logs|test}"
    exit 1
fi
