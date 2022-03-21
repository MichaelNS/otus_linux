#!/bin/bash

# 3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами.

# Для запуска нескольких экземпляров сервиса будем использовать шаблон в конфигурации файла окружения
sudo cat << EOF > /etc/systemd/system/httpd@.service
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd-%I
ExecStart=/usr/sbin/httpd \$OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd \$OPTIONS -k graceful
ExecStop=/bin/kill -WINCH \${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# В самом файле окружения (которых будет два) задается опция для запуска веб-сервера с необходимым конфигурационным файлом:
sudo cat << EOF > /etc/sysconfig/httpd-first
OPTIONS=-f conf/first.conf
EOF

sudo cat << EOF > /etc/sysconfig/httpd-second
OPTIONS=-f conf/second.conf
EOF

# Соответственно в директории с конфигами httpd должны лежать два конфига, в нашем случае это будут first.conf и second.conf
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
sudo sed -i 's/Listen 80/Listen 8000/g' /etc/httpd/conf/first.conf
sudo sh -c "echo 'PidFile /var/run/httpd-first.pid' >> /etc/httpd/conf/first.conf"

sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
sudo sed -i 's/Listen 80/Listen 8001/g' /etc/httpd/conf/second.conf
sudo sh -c "echo 'PidFile /var/run/httpd-second.pid' >> /etc/httpd/conf/second.conf"


# Запускаем сервисы проверяем.
sudo systemctl daemon-reload
sudo systemctl start httpd@first
sudo systemctl enable httpd@first
sudo systemctl start httpd@second
sudo systemctl enable httpd@second

sudo ss -tnulp
