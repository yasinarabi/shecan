#!/bin/bash

HELP="
Usage: $0 COMMAND

Commands:
  help        Show this message
  version     Show version of script
  activate    Activate shecan
  deactivate  Deactivate shecan
  check       Check shecan is working
"
VERSION="0.0.1"
IFS=' '

# Check if the script was invoked with at least one argument
if [ $# -eq 0 ]; then
    echo $HELP
    exit 1
fi

FILE=/etc/resolv.conf
SAMPLE=/etc/resolv.conf.sample

while [[ $# -gt 0 ]]; do
    case $1 in
        h|help)
            echo $HELP
	    ;;
	v|version)
	    echo $VERSION
	    ;;
        a|activate)
            cp $FILE $SAMPLE && printf "%s\n%s\n" "nameserver 178.22.122.100" "nameserver 185.51.200.2" > $FILE
	    ;;
	d|deactivate)
            if [ -f $SAMPLE ]; then
	        cat $SAMPLE > $FILE && rm $SAMPLE
            fi
	    ;;
        c|check)
	    response=$(curl -s -o /dev/null -w "%{http_code}" https://check.shecan.ir)
            if [ $response -eq 200 ]; then
	        echo "Shecan is activated"
            else
	        echo "Shecan is deactivated"
            fi
	    ;;
    esac
    shift
done
exit 0
