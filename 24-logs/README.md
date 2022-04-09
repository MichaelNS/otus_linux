# Домашнее задание.
Настраиваем центральный сервер для сбора логов

Описание/Пошаговая инструкция выполнения домашнего задания:
- в вагранте поднимаем 2 машины web и log
- на web поднимаем nginx
- на log настраиваем центральный лог сервер на любой системе на выбор
journald;
rsyslog;
elk.
- настраиваем аудит, следящий за изменением конфигов нжинкса Все критичные логи с web должны собираться и локально и удаленно. Все логи с nginx должны уходить на удаленный сервер (локально только критичные). Логи аудита должны также уходить на удаленную систему. Формат сдачи ДЗ - vagrant + ansible
развернуть еще машину elk
таким образом настроить 2 центральных лог системы elk и какую либо еще;
- в elk должны уходить только логи нжинкса;
- во вторую систему все остальное.


## Окружение
```
Vagrant 2.2.18
ansible 2.9.27
```

## Развертывание стэнда

В качестве системы логирования выбран rsyslog

### Подготовка стэнда
Готовим ключ. Копируем его в подкаталог ./provision/ssh
```bash
ssh-keygen -t rsa -f ~/.ssh/vagrant-key

cat ~/.ssh/vagrant-key.pub > ./files/authorized_keys
```

### Запуск стенда
```bash
./setup.sh

./play.sh
```

#### Пересоздание стенда
```bash
./destroy.sh && ./setup.sh

./play.sh
```

## Проверка работоспособности
### Проверка записи в nginx_error.log
После развертывания ВМ нужно запустить скрипт, который отправит запросы в nginx для проверки nginx_error.log
```bash
./utest.sh

vagrant ssh log
grep asd /var/log/rsyslog/web/nginx_error.log

less /var/log/rsyslog/web/nginx_error.log
```

### Проверка записи в audit
```bash
vagrant ssh web
sudo su
touch /etc/nginx/nginx.conf
ausearch -f /etc/nginx/nginx.conf
```

```bash
vagrant ssh log
sudo su
ausearch -f /etc/nginx/nginx.conf
```
