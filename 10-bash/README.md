# Домашнее задание Bash Пишем скрипт

Написать скрипт для крона, который раз в час присылает на заданную почту:

1. X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
2. Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
3. все ошибки c момента последнего запуска;
4. Список всех кодов возврата с указанием их кол-ва с момента последнего запуска.

В письме должен быть прописан обрабатываемый временной диапазон и должна быть реализована защита от мультизапуска.

Для проверки ДЗ отредактировать Vagrantfile. В строке
    echo "0 * * * * /vagrant/check_top_req.sh name@domain.com" > cronfile

заменить **name@domain.com** на почту, куда должны быть отправлены письма. После запустить и подождать 1 час.
```
    vagrant up
```

Либо запустить скрипт вручную с помощью команды

```
sudo su
/vagrant/check_top_req.sh name@domain.com
```
Письмо скорее всего попадет в папку спам.
Если почта не приходит, то нужно проверить лог и поискать в нем адрес почты. Возможно были ошибки при отправке письма
```
less /var/log/maillog
```
