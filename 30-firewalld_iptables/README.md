# Домашнее задание.
Сценарии iptables

Описание/Пошаговая инструкция выполнения домашнего задания:
- реализовать knocking port
- centralRouter может попасть на ssh inetrRouter через knock скрипт пример в материалах.
- добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
- запустить nginx на centralServer.
- пробросить 80й порт на inetRouter2 8080.
- дефолт в инет оставить через inetRouter. Формат сдачи ДЗ - vagrant + ansible
- реализовать проход на 80й порт без маскарадинга

# Выполнение ДЗ

## Окружение
```
Vagrant 2.2.19.dev
ansible 2.9.27
```

## Описание стэнда
| Host          | OS |
| ------------- | ----------- |
| inetRouter    | centos/7 |
| centralRouter | centos/7 |
| centralServer | centos/7 |
| inetRouter2   | centos/7 |

## Развертывание стэнда
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
./destroy.sh && ./setup.sh && ./init-base.sh

./play.sh
```


## Проверка работоспособности
Для открытия нужно постучаться по портам в следующем порядке:
8888,7777,6666

Для закрытия 9999,7777,6666

заходим на centralRouter и пробуем зайти по ssh на inetRouter.

```bash
ssh vagrant@192.168.255.1
```

```
[vagrant@centralRouter ~]$ ssh vagrant@192.168.255.1
ssh: connect to host 192.168.255.1 port 22: No route to host
```

Необходимо постучаться с указанием установленной заранее последовательности портов.
```bash
knock -v 192.168.255.1 8888 7777 6666
```

```
[vagrant@centralRouter ~]$ knock -v 192.168.255.1 8888 7777 6666
hitting tcp 192.168.255.1:8888
hitting tcp 192.168.255.1:7777
hitting tcp 192.168.255.1:6666
```

После этого можно войти на inetRouter
```bash
ssh vagrant@192.168.255.1
```

Закрытие соединения
```bash
knock -v 192.168.255.1 9999 7777 6666
```
