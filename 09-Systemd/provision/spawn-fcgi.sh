#!/bin/bash

# 2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi);

# Установка необходтмых компанентов
sudo yum install epel-release -y && sudo yum install spawn-fcgi php php-cli mod_fcgid httpd -y

# Удаление # в строках которые начинаются с SOCKET и OPTIONS в файле spawn-fcgi
sudo sed -i '/SOCKET=/s/^#\+//' /etc/sysconfig/spawn-fcgi
sudo sed -i '/OPTIONS=/s/^#\+//' /etc/sysconfig/spawn-fcgi

# Добавление юнита spawn-fcgi.service
sudo cat << EOF > /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target
[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

# Запускаем сервисы
# Старт spawn-fcgi
systemctl daemon-reload
sudo systemctl start spawn-fcgi
sudo systemctl enable spawn-fcgi
#sudo systemctl status spawn-fcgi
