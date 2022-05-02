# Домашнее задание.
репликация mysql

Описание/Пошаговая инструкция выполнения домашнего задания: \
В материалах приложены ссылки на вагрант для репликации и дамп базы bet.dmp \
Базу развернуть на мастере и настроить так, чтобы реплицировались таблицы: \
| bookmaker | \
| competition | \
| market | \
| odds | \
| outcome

- Настроить GTID репликацию x варианты которые принимаются к сдаче
- рабочий вагрантафайл
- скрины или логи SHOW TABLES
- конфиги
- пример в логе изменения строки и появления строки на реплике


# Выполнение ДЗ

## Окружение
```
Vagrant 2.2.19.dev
ansible 2.11.11
```


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


### Дополнительные действия
```bash
vagrant ssh slave
scp vagrant@192.168.11.150:/tmp/master.sql /tmp/
```

```
[root@slave tmp]# scp vagrant@192.168.11.150:/tmp/master.sql /tmp/
```

Выйти из slave и продолжить выполнение скриптов развертывания

```bash
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml -t mysql_slave
```


## Проверка работоспособности
Зайти на master, добавить запись. Зайти на slave - убедиться, что запись присутствует.

### master

```bash
vagrant ssh master
```

```
mysql> use bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+------------------+
| Tables_in_bet    |
+------------------+
| bookmaker        |
| competition      |
| events_on_demand |
| market           |
| odds             |
| outcome          |
| v_same_event     |
+------------------+
7 rows in set (0.00 sec)

mysql> select * from bet.bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
4 rows in set (0.00 sec)

mysql> insert into bookmaker (id,bookmaker_name) values (1,'OTUS');
Query OK, 1 row affected (0.01 sec)

mysql> select * from bet.bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  1 | OTUS           |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.00 sec)
```

### slave

```bash
vagrant ssh slave
```

```
mysql> use bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+---------------+
| Tables_in_bet |
+---------------+
| bookmaker     |
| competition   |
| market        |
| odds          |
| outcome       |
+---------------+
5 rows in set (0.00 sec)

mysql> select * from bet.bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  1 | OTUS           |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.00 sec)
```
