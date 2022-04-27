# Домашнее задание.
    разворачиваем сетевую лабораторию

Описание/Пошаговая инструкция выполнения домашнего задания:
## otus-linux
Vagrantfile - для стенда урока 9 - Network

## Дано
Vagrantfile с начальным  построением сети
inetRouter
centralRouter
centralServer

тестировалось на virtualbox

## Планируемая архитектура
построить следующую архитектуру

Сеть office1
- 192.168.2.0/26      - dev
- 192.168.2.64/26    - test servers
- 192.168.2.128/26  - managers
- 192.168.2.192/26  - office hardware

Сеть office2
- 192.168.1.0/25      - dev
- 192.168.1.128/26  - test servers
- 192.168.1.192/26  - office hardware


Сеть central
- 192.168.0.0/28    - directors
- 192.168.0.32/28  - office hardware
- 192.168.0.64/26  - wifi

```
Office1 ---\
      -----> Central --IRouter --> internet
Office2----/
```
Итого должны получится следующие сервера
- inetRouter
- centralRouter
- office1Router
- office2Router
- centralServer
- office1Server
- office2Server

## Теоретическая часть
- Найти свободные подсети
- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети
- проверить нет ли ошибок при разбиении

## Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- Формат сдачи ДЗ - vagrant + ansible

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
| office1Router | ubuntu/focal64 |
| office1Server | ubuntu/focal64 |
| office2Router | debian/bullseye64 |
| office2Server | debian/bullseye64 |


Настройка для роутинга office1Server
вводим адрес из сетевого интерфейса, например 192.168.2.130/26
https://ip-calculator.ru/#!ip=192.168.2.130/26
Получаем значение для настройки из min IP:
      routes:
      - to: 0.0.0.0/0
        via: 192.168.2.129



## Развертывание стэнда
### Подготовка стэнда
Установить модуль ansible
ansible-galaxy collection install community.windows

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
```bash
```



# Приложение

```
vagrant snapshot save init

vagrant snapshot restore init

vagrant snapshot restore office1Router init


vagrant destroy office1Router -f
vagrant destroy office1Server -f

vagrant destroy office2Router -f
vagrant destroy office2Server -f

vagrant status


vagrant up office1Server

vagrant up office2Router
```


```
vagrant ssh inetRouter
vagrant ssh centralRouter
vagrant ssh centralServer
vagrant ssh office1Router
vagrant ssh office1Server
vagrant ssh office2Router
vagrant ssh office2Server
```


```
Файл /etc/sysconfig/iptables не обязательно писать с нуля. Можно поступить следующим образом:
Установить iptables и iptables-services
Запустить службу iptables
Внести необходимые правила iptables (и удалить ненужные)

Выполнить команду iptables-save > /etc/sysconfig/iptables
Данная команда сохранит в файл измененные правила

Для их применения нужно перезапустить службу iptables.

yum -y install iptables iptables-services
systemctl enable iptables
vi /etc/sysconfig/iptables
iptables-save > /etc/sysconfig/iptables

systemctl restart iptables
```


```
Строки следующего вида содержат в скобках счетчик пакетов прошедших через интерфейс
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [37:2828]
```



```
Форматирование - ip r | ip-pretty

https://unix.stackexchange.com/questions/391607/pretty-display-of-ip-route

awk '
{   i = 1; h = " ip"
    hdr[h] = 1
    col[h,NR] = $i
    for(i=2;i<=NF;){
        if($i=="linkdown"){extra[NR] = $i; i++; continue}
        hdr[$i] = 1
        col[$i,NR] = $(i+1)
        i += 2
    }
}
END{     #PROCINFO[sorted_in] = "@ind_str_asc"
    n = asorti(hdr,x)
    for(i=1;i<=n;i++){ h = x[i]; max[h] = length(h) }
    for(j = 1;j<=NR;j++){
        for(i=1;i<=n;i++){
            h = x[i]
            l = length(col[h,j])
            if(l>max[h])max[h] = l
        }
    }
    for(i=1;i<=n;i++){ h = x[i]; printf "%-*s ",max[h],h }
    printf "\n"
    for(j = 1;j<=NR;j++){
        for(i=1;i<=n;i++){ h = x[i]; printf "%-*s ",max[h],col[h,j] }
        printf "%s\n",extra[j]
    }
}'

```
