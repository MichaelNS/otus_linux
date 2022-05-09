# Домашнее задание
Настройка PXE сервера для автоматической установки

Цель:
Отрабатываем навыки установки и настройки DHCP, TFTP, PXE загрузчика и автоматической загрузки

Описание/Пошаговая инструкция выполнения домашнего задания:
Следуя шагам из документа https://docs.centos.org/en-US/8-docs/advanced-install/assembly_preparing-for-a-network-install установить и настроить загрузку по сети для дистрибутива CentOS8. В качестве шаблона воспользуйтесь репозиторием https://github.com/nixuser/virtlab/tree/main/centos_pxe.
Поменять установку из репозитория NFS на установку из репозитория HTTP.
Настройить автоматическую установку для созданного kickstart файла (*) Файл загружается по HTTP.
автоматизировать процесс установки Cobbler cледуя шагам из документа https://cobbler.github.io/quickstart/. Формат сдачи ДЗ - vagrant + ansible
Критерии оценки:
Статус "Принято" ставится при выполнении следующих условий:

Ссылка на репозиторий github.
Vagrantfile с шагами установки необходимых компонентов
Исходный код scripts для настройки сервера (если необходимо)
Если какие-то шаги невозможно или сложно автоматизировать, то инструкции по ручным шагам для настройки Задание со звездочкой выполняется по желанию.


## Окружение
```
Vagrant 2.2.19.dev
ansible 2.9.27
```

## Развертывание стэнда

В качестве системы логирования выбран rsyslog

### Подготовка стэнда
Скачать iso-образ вручную

```bash
wget https://mirror.sale-dedic.com/centos/8.4.2105/isos/x86_64/CentOS-8.4.2105-x86_64-dvd1.iso
```

### Запуск стенда
```bash
./setup.sh

```

#### Удаление стенда
```bash
./destroy.sh
```

После сбоя загрузки клиента ВМ...:
```
==> pxeclient: Waiting for machine to boot. This may take a few minutes...
    pxeclient: SSH address: 127.0.0.1:22
    pxeclient: SSH username: vagrant
    pxeclient: SSH auth method: private key
    pxeclient: Warning: Connection refused. Retrying...
Timed out while waiting for the machine to boot. This means that
Vagrant was unable to communicate with the guest machine within
the configured ("config.vm.boot_timeout" value) time period.

If you look above, you should be able to see the error(s) that
Vagrant had when attempting to connect to the machine. These errors
are usually good hints as to what may be wrong.

If you're using a custom box, make sure that networking is properly
working and you're able to connect to the machine. It is a common
problem that networking isn't setup properly in these boxes.
Verify that authentication configurations are also setup properly,
as well.

If the box appears to be booting properly, you may want to increase
the timeout ("config.vm.boot_timeout") value.

```

Нужно продолжить развертывание стенда - запустить ansible
```bash
./play.sh

```

#### Ручные операции
Для ускорения процесса развертывания ВМ скачиваем образ заранее и копируем заранее скачанный файл
```bash
wget https://mirror.sale-dedic.com/centos/8.4.2105/isos/x86_64/CentOS-8.4.2105-x86_64-dvd1.iso

scp -i .vagrant/machines/pxeserver/virtualbox/private_key .../CentOS-8.4.2105-x86_64-dvd1.iso vagrant@192.168.50.20:/images
```

Выполняем развертывание далее
```bash
./playstage2.sh
```

## Проверка работоспособности
Открыть VirtualBox и запустить pxeclient
