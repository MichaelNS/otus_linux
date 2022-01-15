#!/bin/bash

fmt="%-10s%-10s%-60s%-5s%-10s\n"
printf "$fmt" USER PID STAT RSS COMMAND

for proc in $(find /proc -maxdepth 1 -type d -printf "%f\n" | grep -E "^[0-9]" | sort -n)
do

    if [[ -f /proc/$proc/status ]]
        then
        PID=$proc

    COMMAND=$(cat /proc/"$proc"/cmdline | strings -1)
    if [ "$COMMAND" != '' ]
        then
        COMMAND="[$(awk '/Name/{print $2}' /proc/"$proc"/status)]"
    else
        COMMAND=$(cat /proc/"$proc"/cmdline)
    fi

    User=$(awk '/Uid/{print $2}' /proc/"$proc"/status)
    Stat=$(cat /proc/"$proc"/status | awk '/State/{print $2}')
    RSS=$(cat /proc/"$proc"/status | awk '/VmRSS/{print $2}')
    if [[ User -eq 0 ]]
       then
       UserName='root'
    else
       UserName=$(grep "$User" /etc/passwd | awk -F ":" '{print $1}')
    fi
    printf "$fmt" "$UserName" "$PID" "$Stat" "$RSS" "$COMMAND"
    fi
done

