# Домашнее задание.
OSPF

- Описание/Пошаговая инструкция выполнения домашнего задания:
- Поднять три виртуалки
- Объединить их разными vlan
- поднять OSPF между машинами на базе Quagga;
- изобразить ассиметричный роутинг;
- сделать один из линков "дорогим", но что бы при этом роутинг был симметричным. Формат сдачи: Vagrantfile + ansible

## Окружение
```
Vagrant 2.2.19.dev
ansible 2.9.27
```

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
./destroy.sh && ./setup.sh

./play.sh
```

## Проверка работоспособности

### Настройка для ассиметричного роутинга

```bash
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml -t asymmetric
```

```
root@router2:/home/vagrant# tcpdump -i enp0s8
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
13:49:39.309757 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 5, length 64
13:49:40.330966 ARP, Request who-has 10.0.10.1 tell router2, length 28
13:49:40.331460 ARP, Reply 10.0.10.1 is-at 08:00:27:56:68:21 (oui Unknown), length 46
13:49:40.333615 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 6, length 64
13:49:41.357751 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 7, length 64
13:49:42.381772 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 8, length 64
13:49:43.405717 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 9, length 64
13:49:44.429673 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 10, length 64
13:49:45.456857 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 11, length 64
13:49:46.477767 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 12, length 64
13:49:47.501788 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 13, length 64
13:49:48.312742 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:49:48.342660 IP 10.0.10.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:49:48.528922 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 14, length 64
13:49:49.549710 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 15, length 64
13:49:50.573788 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 16, length 64
13:49:51.601376 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 17, length 64
13:49:52.621746 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 18, length 64
13:49:53.645751 IP router2 > 192.168.10.1: ICMP echo reply, id 15, seq 19, length 64
^C
19 packets captured
19 packets received by filter
0 packets dropped by kernel
root@router2:/home/vagrant# tcpdump -i enp0s9
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s9, link-type EN10MB (Ethernet), capture size 262144 bytes
13:49:57.741873 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 23, length 64
13:49:58.312843 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:49:58.390389 IP 10.0.11.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:49:58.765547 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 24, length 64
13:49:59.789806 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 25, length 64
13:50:00.813789 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 26, length 64
13:50:01.837730 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 27, length 64
13:50:02.861661 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 28, length 64
13:50:03.885742 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 29, length 64
13:50:04.886902 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 30, length 64
13:50:05.902686 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 31, length 64
13:50:06.925830 IP 192.168.10.1 > router2: ICMP echo request, id 15, seq 32, length 64
^C
12 packets captured
12 packets received by filter
0 packets dropped by kernel

```


### Настройка для симетричного роутинга

```bash
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml -t symmetric
```

```
root@router2:/home/vagrant# tcpdump -i enp0s8
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
13:52:17.748792 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:52:18.354885 IP 10.0.10.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:52:27.748820 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:52:28.354894 IP 10.0.10.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:52:37.748934 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:52:38.355010 IP 10.0.10.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:52:47.748972 IP router2 > ospf-all.mcast.net: OSPFv2, Hello, length 48
13:52:48.354973 IP 10.0.10.1 > ospf-all.mcast.net: OSPFv2, Hello, length 48
^C
8 packets captured
8 packets received by filter
0 packets dropped by kernel
root@router2:/home/vagrant# tcpdump -i enp0s9
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s9, link-type EN10MB (Ethernet), capture size 262144 bytes
13:52:52.363117 IP 192.168.10.1 > router2: ICMP echo request, id 16, seq 47, length 64
13:52:52.363167 IP router2 > 192.168.10.1: ICMP echo reply, id 16, seq 47, length 64
13:52:53.389713 IP 192.168.10.1 > router2: ICMP echo request, id 16, seq 48, length 64
13:52:53.389770 IP router2 > 192.168.10.1: ICMP echo reply, id 16, seq 48, length 64
13:52:54.413764 IP 192.168.10.1 > router2: ICMP echo request, id 16, seq 49, length 64
13:52:54.413816 IP router2 > 192.168.10.1: ICMP echo reply, id 16, seq 49, length 64
13:52:55.437724 IP 192.168.10.1 > router2: ICMP echo request, id 16, seq 50, length 64
13:52:55.437795 IP router2 > 192.168.10.1: ICMP echo reply, id 16, seq 50, length 64
13:52:56.493912 IP 192.168.10.1 > router2: ICMP echo request, id 16, seq 51, length 64
13:52:56.493981 IP router2 > 192.168.10.1: ICMP echo reply, id 16, seq 51, length 64
13:52:57.494076 IP 192.168.10.1 > router2: ICMP echo request, id 16, seq 52, length 64
13:52:57.494153 IP router2 > 192.168.10.1: ICMP echo reply, id 16, seq 52, length 64
^C
12 packets captured
12 packets received by filter
0 packets dropped by kernel

```