#!/bin/bash

# Проверка watchlog.timer
echo "=================================================================================================================================="
echo "========= Test watchlog.timer :"

sudo tail -n 30 /var/log/messages
printf '\nGREP :'
sudo grep "Master" /var/log/messages

echo "END test watchlog.timer"

echo "=================================================================================================================================="

echo "Test spawn-fcgi :"
sudo systemctl status spawn-fcgi

echo "=================================================================================================================================="

echo "Test httpd-multi :"
sudo ss -tnulp
