#!/bin/bash

# 1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig)

# Для начала создаём файл с конфигурацией для сервиса в директории
# /etc/sysconfig - из неё сервис будет брать необходимые переменные.
sudo cat << EOF > /etc/sysconfig/watchlog
# Configuration file for my watchdog service
# Place it to /etc/sysconfig
# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF

#  Затем создаем /var/log/watchlog.log и пишем туда строки на своё усмотрение, плюс ключевое слово ‘ALERT’
sudo cat << EOF > /var/log/watchlog.log
ALERT Feb 26 16:49:27 terraform-instance systemd: Started My watchlog service.
ALERT Feb 26 16:48:57 terraform-instance systemd: Started My watchlog service.
EOF

# Скрипт читающий входящий лог файл /var/log/watchlog.log и отслеживающий
# ключевое слово ALERT, а также пишет данные в лог если найдено совпадение.
sudo cat << EOF > /opt/watchlog.sh
#!/bin/bash
WORD=\$1
LOG=\$2
DATE=\$(date)

if grep \$WORD \$LOG &> /dev/null
then
   logger "\$DATE: I found word, Master!"
else
   exit 0
fi
EOF

# Служба, запускающая скрипт /opt/watchlog.sh обработки лог файла /var/log/watchlog.log

sudo cat << EOF > /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
[Install]
WantedBy=multi-user.target
EOF

# Служба таймера, запускающая службу watchlog каждые 30 секунд.

sudo cat << EOF > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 second
[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service
[Install]
WantedBy=multi-user.target
EOF

sudo chmod +x /opt/watchlog.sh

# Старт watchlog.timer
sudo systemctl enable watchlog
sudo systemctl start watchlog
sudo systemctl start watchlog.timer
sudo systemctl enable watchlog.timer
sudo systemctl status watchlog.timer

#sudo tail -f /var/log/messages
