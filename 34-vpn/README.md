# Домашнее задание.
VPN

Описание/Пошаговая инструкция выполнения домашнего задания:
1. Между двумя виртуалками поднять vpn в режимах
- tun;
- tap; Прочуствовать разницу.
2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку.\
3.* Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке Формат сдачи ДЗ - vagrant + ansible


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


Устанавливаем значение переменной для роли **cert** каталогом, где хранится проект \
cert_path: /mnt/.../.../34-vpn/provisioning/roles/cert/files/


### Запуск стенда
```bash
./setup.sh && ./init-base.sh

```

#### Пересоздание стенда
```bash
./destroy.sh && ./setup.sh && ./init-base.sh

```



## Проверка работоспособности

```bash
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml -t cert

```


### Полезные команды

server
```bash
iperf3 -s

pkill iperf

```


```bash
sudo systemctl stop openvpn@server

sudo systemctl start openvpn@server

sudo systemctl status openvpn@server


sudo systemctl stop openvpn@server && sudo systemctl start openvpn@server && sudo systemctl status openvpn@server

```


### Режим tap
```bash
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml -t tap
```




```
[root@server vagrant]# iperf3 -s &
[1] 26388
[root@server vagrant]# -----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 44344
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 56890
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec  4.66 MBytes  38.9 Mbits/sec  0.594 ms  4479/8180 (55%)  
[  5]   1.00-2.00   sec  6.09 MBytes  51.2 Mbits/sec  0.503 ms  4728/9566 (49%)  
[  5]   2.00-3.01   sec  4.75 MBytes  39.6 Mbits/sec  0.613 ms  5642/9410 (60%)  
[  5]   3.01-4.01   sec  4.70 MBytes  39.3 Mbits/sec  0.629 ms  5776/9508 (61%)  
[  5]   4.01-5.00   sec  4.57 MBytes  38.6 Mbits/sec  0.622 ms  5799/9427 (62%)  
[  5]   5.00-6.00   sec  5.16 MBytes  43.3 Mbits/sec  0.626 ms  5247/9345 (56%)  
[  5]   6.00-7.01   sec  5.13 MBytes  43.0 Mbits/sec  0.609 ms  5469/9541 (57%)  
[  5]   7.01-8.00   sec  7.45 MBytes  62.8 Mbits/sec  0.062 ms  3548/9462 (37%)  
[  5]   8.00-9.00   sec  6.93 MBytes  58.1 Mbits/sec  0.096 ms  4139/9639 (43%)  
[  5]   9.00-10.00  sec  5.67 MBytes  47.5 Mbits/sec  0.600 ms  4681/9183 (51%)  
[  5]  10.00-11.00  sec  5.15 MBytes  43.1 Mbits/sec  0.617 ms  5477/9568 (57%)  
[  5]  11.00-12.01  sec  4.73 MBytes  39.5 Mbits/sec  0.623 ms  5743/9494 (60%)  
[  5]  12.01-13.00  sec  5.45 MBytes  45.9 Mbits/sec  0.620 ms  5122/9446 (54%)  
[  5]  13.00-14.01  sec  5.42 MBytes  45.4 Mbits/sec  0.602 ms  5151/9456 (54%)  
[  5]  14.01-15.00  sec  5.60 MBytes  47.0 Mbits/sec  0.607 ms  4933/9378 (53%)  
[  5]  15.00-16.01  sec  5.20 MBytes  43.6 Mbits/sec  0.603 ms  5411/9540 (57%)  
[  5]  16.01-17.00  sec  5.45 MBytes  45.8 Mbits/sec  0.219 ms  5144/9467 (54%)  
[  5]  17.00-18.01  sec  5.45 MBytes  45.6 Mbits/sec  0.608 ms  5138/9465 (54%)  
[  5]  18.01-19.00  sec  4.97 MBytes  41.8 Mbits/sec  0.554 ms  5556/9503 (58%)  
[  5]  19.00-20.01  sec  5.21 MBytes  43.6 Mbits/sec  0.586 ms  5340/9474 (56%)  
[  5]  20.01-21.01  sec  4.96 MBytes  41.6 Mbits/sec  0.484 ms  5536/9473 (58%)  
[  5]  21.01-22.01  sec  5.22 MBytes  43.8 Mbits/sec  0.621 ms  5259/9399 (56%)  
[  5]  22.01-23.00  sec  6.20 MBytes  52.1 Mbits/sec  0.530 ms  4593/9518 (48%)  
[  5]  23.00-24.00  sec  4.75 MBytes  39.9 Mbits/sec  0.579 ms  5649/9422 (60%)  
[  5]  24.00-25.01  sec  5.29 MBytes  44.3 Mbits/sec  0.633 ms  5273/9475 (56%)  
[  5]  25.01-26.00  sec  5.10 MBytes  43.0 Mbits/sec  0.642 ms  5322/9367 (57%)  
[  5]  26.00-27.01  sec  5.39 MBytes  45.0 Mbits/sec  0.605 ms  5248/9526 (55%)  
[  5]  27.01-28.01  sec  5.22 MBytes  43.7 Mbits/sec  0.400 ms  5438/9580 (57%)  
[  5]  28.01-29.01  sec  5.59 MBytes  46.9 Mbits/sec  0.666 ms  4824/9263 (52%)  
[  5]  29.01-30.01  sec  5.10 MBytes  42.8 Mbits/sec  0.628 ms  5585/9634 (58%)  
[  5]  30.01-31.01  sec  5.03 MBytes  42.2 Mbits/sec  0.594 ms  5418/9414 (58%)  
[  5]  31.01-32.01  sec  5.48 MBytes  45.9 Mbits/sec  0.591 ms  5141/9487 (54%)  
[  5]  32.01-33.01  sec  4.90 MBytes  41.2 Mbits/sec  0.614 ms  5536/9423 (59%)  
[  5]  33.01-34.00  sec  5.17 MBytes  43.5 Mbits/sec  0.643 ms  5324/9429 (56%)  
[  5]  34.00-35.00  sec  4.69 MBytes  39.5 Mbits/sec  0.504 ms  5699/9422 (60%)  
[  5]  35.00-36.01  sec  6.08 MBytes  50.8 Mbits/sec  0.491 ms  4727/9554 (49%)  
[  5]  36.01-37.01  sec  5.55 MBytes  46.6 Mbits/sec  0.604 ms  5038/9444 (53%)  
[  5]  37.01-38.00  sec  5.57 MBytes  46.8 Mbits/sec  0.557 ms  5061/9486 (53%)  
[  5]  38.00-39.00  sec  5.23 MBytes  43.8 Mbits/sec  0.598 ms  5309/9459 (56%)  
[  5]  39.00-40.00  sec  5.53 MBytes  46.6 Mbits/sec  0.673 ms  4751/9142 (52%)  
[  5]  40.00-40.06  sec   178 KBytes  24.6 Mbits/sec  0.034 ms  363/501 (72%)  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-40.06  sec  0.00 Bytes  0.00 bits/sec  0.034 ms  207617/377470 (55%)  
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------


```





```
[root@client openvpn]# iperf3 -c 10.10.10.1 -i 5 -t 40 -b 100M -u
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 56890 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-5.00   sec  58.5 MBytes  98.1 Mbits/sec  46423  
[  4]   5.00-10.00  sec  59.6 MBytes   100 Mbits/sec  47329  
[  4]  10.00-15.00  sec  59.6 MBytes   100 Mbits/sec  47302  
[  4]  15.00-20.00  sec  59.6 MBytes   100 Mbits/sec  47321  
[  4]  20.00-25.00  sec  59.6 MBytes  99.9 Mbits/sec  47288  
[  4]  25.00-30.00  sec  59.6 MBytes   100 Mbits/sec  47326  
[  4]  30.00-35.00  sec  59.6 MBytes  99.9 Mbits/sec  47285  
[  4]  35.00-40.00  sec  59.6 MBytes   100 Mbits/sec  47343  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  4]   0.00-40.00  sec   476 MBytes  99.8 Mbits/sec  0.034 ms  207617/377470 (55%)  
[  4] Sent 377470 datagrams

iperf Done.



```




### Режим tun
```bash
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml -t tun

```


```
[root@server vagrant]# iperf3 -s &
[1] 25989
[root@server vagrant]# -----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 44342
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 40702
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec  3.44 MBytes  28.8 Mbits/sec  0.010 ms  5315/7979 (67%)  
[  5]   1.00-2.00   sec  3.26 MBytes  27.3 Mbits/sec  0.005 ms  6616/9141 (72%)  
[  5]   2.00-3.00   sec  3.58 MBytes  30.0 Mbits/sec  0.005 ms  6455/9232 (70%)  
[  5]   3.00-4.00   sec  3.42 MBytes  28.8 Mbits/sec  0.013 ms  6566/9219 (71%)  
[  5]   4.00-5.00   sec  3.68 MBytes  30.9 Mbits/sec  0.005 ms  6461/9313 (69%)  
[  5]   5.00-6.00   sec  3.71 MBytes  31.1 Mbits/sec  0.006 ms  6221/9095 (68%)  
[  5]   6.00-7.00   sec  3.46 MBytes  29.0 Mbits/sec  0.005 ms  6606/9289 (71%)  
[  5]   7.00-8.00   sec  3.82 MBytes  32.0 Mbits/sec  0.007 ms  6233/9193 (68%)  
[  5]   8.00-9.00   sec  3.24 MBytes  27.2 Mbits/sec  0.010 ms  6739/9253 (73%)  
[  5]   9.00-10.00  sec  3.58 MBytes  30.0 Mbits/sec  0.014 ms  6577/9348 (70%)  
[  5]  10.00-11.00  sec  3.20 MBytes  26.9 Mbits/sec  0.034 ms  6539/9022 (72%)  
[  5]  11.00-12.00  sec  3.64 MBytes  30.5 Mbits/sec  0.005 ms  6614/9434 (70%)  
[  5]  12.00-13.00  sec  3.98 MBytes  33.4 Mbits/sec  0.010 ms  5986/9074 (66%)  
[  5]  13.00-14.00  sec  3.25 MBytes  27.2 Mbits/sec  0.007 ms  6915/9430 (73%)  
[  5]  14.00-15.00  sec  3.05 MBytes  25.6 Mbits/sec  0.006 ms  6842/9206 (74%)  
[  5]  15.00-16.00  sec  3.28 MBytes  27.5 Mbits/sec  0.007 ms  6665/9204 (72%)  
[  5]  16.00-17.00  sec  2.95 MBytes  24.8 Mbits/sec  0.006 ms  6805/9093 (75%)  
[  5]  17.00-18.00  sec  3.33 MBytes  28.0 Mbits/sec  0.012 ms  6813/9397 (73%)  
[  5]  18.00-19.00  sec  3.32 MBytes  27.8 Mbits/sec  0.014 ms  6656/9227 (72%)  
[  5]  19.00-20.00  sec  3.14 MBytes  26.4 Mbits/sec  0.018 ms  6550/8985 (73%)  
[  5]  20.00-21.00  sec  3.31 MBytes  27.7 Mbits/sec  0.008 ms  6897/9459 (73%)  
[  5]  21.00-22.00  sec  3.59 MBytes  30.1 Mbits/sec  0.005 ms  6537/9321 (70%)  
[  5]  22.00-23.00  sec  3.71 MBytes  31.2 Mbits/sec  0.006 ms  6290/9168 (69%)  
[  5]  23.00-24.00  sec  3.69 MBytes  31.0 Mbits/sec  0.097 ms  6495/9358 (69%)  
[  5]  24.00-25.00  sec  3.42 MBytes  28.7 Mbits/sec  0.017 ms  6575/9228 (71%)  
[  5]  25.00-26.00  sec  3.27 MBytes  27.4 Mbits/sec  0.002 ms  6651/9185 (72%)  
[  5]  26.00-27.00  sec  3.76 MBytes  31.6 Mbits/sec  0.005 ms  6367/9282 (69%)  
[  5]  27.00-28.00  sec  3.53 MBytes  29.6 Mbits/sec  0.014 ms  6553/9288 (71%)  
[  5]  28.00-29.00  sec  3.55 MBytes  29.8 Mbits/sec  0.006 ms  6459/9210 (70%)  
[  5]  29.00-30.00  sec  3.70 MBytes  31.1 Mbits/sec  0.051 ms  6367/9237 (69%)  
[  5]  30.00-31.00  sec  3.36 MBytes  28.2 Mbits/sec  0.005 ms  6557/9162 (72%)  
[  5]  31.00-32.00  sec  3.18 MBytes  26.6 Mbits/sec  0.006 ms  6667/9128 (73%)  
[  5]  32.00-33.00  sec  3.57 MBytes  29.9 Mbits/sec  0.005 ms  6598/9364 (70%)  
[  5]  33.00-34.00  sec  3.32 MBytes  27.9 Mbits/sec  0.005 ms  6708/9283 (72%)  
[  5]  34.00-35.00  sec  3.51 MBytes  29.4 Mbits/sec  0.007 ms  6531/9249 (71%)  
[  5]  35.00-36.00  sec  3.53 MBytes  29.6 Mbits/sec  0.006 ms  6439/9175 (70%)  
[  5]  36.00-37.00  sec  3.15 MBytes  26.4 Mbits/sec  0.007 ms  6815/9255 (74%)  
[  5]  37.00-38.00  sec  3.29 MBytes  27.6 Mbits/sec  0.002 ms  6635/9184 (72%)  
[  5]  38.00-39.00  sec  3.60 MBytes  30.2 Mbits/sec  0.003 ms  6495/9283 (70%)  
[  5]  39.00-40.00  sec  3.29 MBytes  27.6 Mbits/sec  0.009 ms  6736/9282 (73%)  
[  5]  40.00-40.05  sec  0.00 Bytes  0.00 bits/sec  0.009 ms  0/0 (0%)  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  5]   0.00-40.05  sec  0.00 Bytes  0.00 bits/sec  0.009 ms  261546/368235 (71%)  
-----------------------------------------------------------
Server listening on 5201

```



```
[root@client openvpn]# iperf3 -c 10.10.10.1 -i 5 -t 40 -b 100M -u
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 40702 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Total Datagrams
[  4]   0.00-5.00   sec  58.5 MBytes  98.1 Mbits/sec  45322  
[  4]   5.00-10.00  sec  59.6 MBytes   100 Mbits/sec  46199  
[  4]  10.00-15.00  sec  59.6 MBytes   100 Mbits/sec  46193  
[  4]  15.00-20.00  sec  59.6 MBytes   100 Mbits/sec  46188  
[  4]  20.00-25.00  sec  59.6 MBytes   100 Mbits/sec  46194  
[  4]  25.00-30.00  sec  59.6 MBytes   100 Mbits/sec  46197  
[  4]  30.00-35.00  sec  59.6 MBytes   100 Mbits/sec  46197  
[  4]  35.00-40.00  sec  59.6 MBytes   100 Mbits/sec  46198  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
[  4]   0.00-40.00  sec   476 MBytes  99.8 Mbits/sec  0.009 ms  261546/368235 (71%)  
[  4] Sent 368235 datagrams

iperf Done.

```




### RAS

Дополнительных действий не требуется. Развертывание было выполнено в рамках роли ras

Проверям логи на сервере.

```
[root@server vagrant]# less /var/log/openvpn-status.log

OpenVPN CLIENT LIST
Updated,Mon Apr 25 00:36:17 2022
Common Name,Real Address,Bytes Received,Bytes Sent,Connected Since
client,172.20.30.1:1194,4118,3819,Mon Apr 25 00:32:37 2022
ROUTING TABLE
Virtual Address,Common Name,Real Address,Last Ref
10.10.10.6,client,172.20.30.1:1194,Mon Apr 25 00:33:05 2022
192.168.33.0/24,client,172.20.30.1:1194,Mon Apr 25 00:32:37 2022
GLOBAL STATS
Max bcast/mcast queue length,0
END
```


На хостовой машине переходим в root иначе не будет работать.
```
[root]# openvpn --config client.conf
Mon Apr 25 00:32:37 2022 WARNING: file './client.key' is group or others accessible
Mon Apr 25 00:32:37 2022 OpenVPN 2.4.4 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Mar 22 2022
Mon Apr 25 00:32:37 2022 library versions: OpenSSL 1.1.1  11 Sep 2018, LZO 2.08
Mon Apr 25 00:32:37 2022 TCP/UDP: Preserving recently used remote address: [AF_INET]172.20.30.10:1207
Mon Apr 25 00:32:37 2022 Socket Buffers: R=[212992->212992] S=[212992->212992]
Mon Apr 25 00:32:37 2022 UDP link local (bound): [AF_INET][undef]:1194
Mon Apr 25 00:32:37 2022 UDP link remote: [AF_INET]172.20.30.10:1207
Mon Apr 25 00:32:37 2022 TLS: Initial packet from [AF_INET]172.20.30.10:1207, sid=7b9803c1 e8cc5847
Mon Apr 25 00:32:37 2022 VERIFY OK: depth=1, CN=rasvpn
Mon Apr 25 00:32:37 2022 VERIFY KU OK
Mon Apr 25 00:32:37 2022 Validating certificate extended key usage
Mon Apr 25 00:32:37 2022 ++ Certificate has EKU (str) TLS Web Server Authentication, expects TLS Web Server Authentication
Mon Apr 25 00:32:37 2022 VERIFY EKU OK
Mon Apr 25 00:32:37 2022 VERIFY OK: depth=0, CN=rasvpn
Mon Apr 25 00:32:37 2022 Control Channel: TLSv1.2, cipher TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384, 2048 bit RSA
Mon Apr 25 00:32:37 2022 [rasvpn] Peer Connection Initiated with [AF_INET]172.20.30.10:1207
Mon Apr 25 00:32:38 2022 SENT CONTROL [rasvpn]: 'PUSH_REQUEST' (status=1)
Mon Apr 25 00:32:38 2022 PUSH: Received control message: 'PUSH_REPLY,route 10.10.10.0 255.255.255.0,topology net30,ping 10,ping-restart 120,ifconfig 10.10.10.6 10.10.10.5,peer-id 0,cipher AES-256-GCM'
Mon Apr 25 00:32:38 2022 OPTIONS IMPORT: timers and/or timeouts modified
Mon Apr 25 00:32:38 2022 OPTIONS IMPORT: --ifconfig/up options modified
Mon Apr 25 00:32:38 2022 OPTIONS IMPORT: route options modified
Mon Apr 25 00:32:38 2022 OPTIONS IMPORT: peer-id set
Mon Apr 25 00:32:38 2022 OPTIONS IMPORT: adjusting link_mtu to 1625
Mon Apr 25 00:32:38 2022 OPTIONS IMPORT: data channel crypto options modified
Mon Apr 25 00:32:38 2022 Data Channel: using negotiated cipher 'AES-256-GCM'
Mon Apr 25 00:32:38 2022 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Mon Apr 25 00:32:38 2022 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Mon Apr 25 00:32:38 2022 ROUTE_GATEWAY 192.168.1.1/255.255.255.0 IFACE=wl HWADDR=
Mon Apr 25 00:32:38 2022 TUN/TAP device tun0 opened
Mon Apr 25 00:32:38 2022 TUN/TAP TX queue length set to 100
Mon Apr 25 00:32:38 2022 do_ifconfig, tt->did_ifconfig_ipv6_setup=0
Mon Apr 25 00:32:38 2022 /sbin/ip link set dev tun0 up mtu 1500
Mon Apr 25 00:32:38 2022 /sbin/ip addr add dev tun0 local 10.10.10.6 peer 10.10.10.5
Mon Apr 25 00:32:38 2022 /sbin/ip route add 172.20.30.0/24 via 10.10.10.5
RTNETLINK answers: File exists
Mon Apr 25 00:32:38 2022 ERROR: Linux route add command failed: external program exited with error status: 2
Mon Apr 25 00:32:38 2022 /sbin/ip route add 10.10.10.0/24 via 10.10.10.5
Mon Apr 25 00:32:38 2022 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Mon Apr 25 00:32:38 2022 Initialization Sequence Completed
```


Проверяем на хостовой машине:
```
ping -c 4 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.644 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.881 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=0.717 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=0.596 ms

--- 10.10.10.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3065ms
rtt min/avg/max/mdev = 0.596/0.709/0.881/0.111 ms
```

```
ip r

172.20.30.0/24 dev vboxnet2 proto kernel scope link src 172.20.30.1 

192.168.10.0/24 dev vboxnet1 proto kernel scope link src 192.168.10.1 
192.168.49.0/24 dev br-cf56344933ea proto kernel scope link src 192.168.49.1 linkdown 
```
