# Домашнее задание.
LDAP

Описание/Пошаговая инструкция выполнения домашнего задания:
- Установить FreeIPA;
- Написать Ansible playbook для конфигурации клиента;
- ** Настроить аутентификацию по SSH-ключам;
- *** Firewall должен быть включен на сервере и на клиенте.

Формат сдачи ДЗ - vagrant + ansible

# Выполнение ДЗ

## Окружение
```
Vagrant 2.2.19.dev
ansible 2.11.11
```

## Описание стэнда
| Host          | OS |
| ------------- | ----------- |
| ipaserver     | centos/7 |
| ipaclient     | centos/7 |

## Развертывание стенда
### Подготовка стенда

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
./destroy.sh && ./setup.sh && ./play.sh
```


### Настройка hosts
на своем хосте в /etc/hosts добавляем запись сервера IPA:
192.168.50.10 ipaserver.hw38.otus







## FreeIPA Server

Для корректной работы FreeIPA hostname у машин должен быть в формате fqdn

```
- name: Set FQDN hostname
  hostname:
    name: '{{ ipa_server_fqdn }}'
```

Так же добавим в /etc/hosts записи с fqdn именами сервера и клиента

```
- name: Add FQDN entries to /etc/hosts
  lineinfile:
    path: /etc/hosts
    line: "{{ item }}"
  loop:
    - '{{ ipa_server_ip }} {{ ipa_server_fqdn }} {{ ipa_server_fqdn }}'
    - '{{ ipa_client_ip }} {{ ipa_client_fqdn }} {{ ipa_client_fqdn }}'
```

Запустим *firewalld*

```
- name: Start and enable firewalld
  service:
    name: firewalld
    state: restarted
    enabled: true
```

Установка FreeIPA server происходит в *unattended* режиме? с передачей всех необходимых параметров в cli

```
- name: Install ipa server
  command:
    cmd: |
      ipa-server-install -U
      --realm {{ ipa_realm }}
      --domain {{ ipa_domain }}
      --hostname={{ ipa_server_fqdn }}
      --ip-address={{ ipa_server_ip }}
      --setup-dns
      --auto-forwarders
      --no-reverse
      --mkhomedir
      -a Otus2022
      -p Otus2022
    creates: /etc/ipa/default.conf
```

Далее создаются sudorule OTUS c разрешением на выполнение всех команд. К этому правилу добавляем группу admins

```
- name: Add ipa sudorule
  shell: ipa sudorule-add --cmdcat=all OTUS

- name: Grant admins group with OTUS sudorule
  shell: ipa sudorule-add-user --groups=admins OTUS
```

Создаем в ipa нового пользователя otus, и добавляем его в группу admins

```
- name: Create new ipa user
  shell: echo "Otus2022" | ipa user-add otus --first=Otus --last=Otusov --email=ootusov@otus.ru --shell=/bin/bash --sshpubkey="{{ ipa_user_pub_key }}" --password

- name: Add otus user to admins group
  shell: ipa group-add-member admins --users=otus
```


Последним шагом разрешаем входящие подключения к портам FreeIPA в firewall

```
- name: Add firewalld ipa service
  shell: |
    firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps &&
    firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent
```

## FreeIPA Client

Клиент устанавливается также в *unattended* режиме

```
- name: Install ipa client
  command:
    cmd: |
      ipa-client-install -U
      --realm {{ ipa_realm }}
      --domain {{ ipa_domain }}
      --server={{ ipa_server_fqdn }}
      --ip-address={{ ipa_server_ip }}
      --hostname={{ ipa_client_fqdn }}
      --mkhomedir
      --force-ntpd
      -p admin
      -w Otus2022
    creates: /etc/ipa/default.conf
```

Далее, как и на сервере, создается homedir пользователя otus, и копируется приватный ключ.


## Проверка работоспособности

Зайти на сайт https://ipaserver.hw38.otus/

Логин - amdin
Пароль - Otus2022



<details>
<summary>IPA Server</summary>

```
[vagrant@ipaserver ~]$ echo "Otus2022" | kinit admin
Password for admin@HW38.OTUS:
[vagrant@ipaserver ~]$ ipa user-find --all
---------------
2 users matched
---------------
  dn: uid=admin,cn=users,cn=accounts,dc=hw38,dc=otus
  User login: admin
  Last name: Administrator
  Full name: Administrator
  Home directory: /home/admin
  GECOS: Administrator
  Login shell: /bin/bash
  Principal alias: admin@HW38.OTUS
  User password expiration: 20220916213310Z
  UID: 456000000
  GID: 456000000
  Account disabled: False
  Preserved user: False
  Member of groups: admins, trust admins
  Member of Sudo rule: OTUS
  ipauniqueid: a698f2fc-ef4d-11ec-8a9e-5254004d77d3
  krbextradata: AAKWRK5icm9vdC9hZG1pbkBIVzM4Lk9UVVMA
  krblastpwdchange: 20220618213310Z
  objectclass: top, person, posixaccount, krbprincipalaux, krbticketpolicyaux, inetuser, ipaobject, ipasshuser, ipaSshGroupOfPubKeys

  dn: uid=nomad,cn=users,cn=accounts,dc=hw38,dc=otus
  User login: nomad
  First name: Otus
  Last name: Otusov
  Full name: Otus Otusov
  Display name: Otus Otusov
  Initials: OO
  Home directory: /home/nomad
  GECOS: Otus Otusov
  Login shell: /bin/bash
  Principal name: nomad@HW38.OTUS
  Principal alias: nomad@HW38.OTUS
  User password expiration: 20220618213459Z
  Email address: ootusov@otus.ru
  UID: 456000001
  GID: 456000001
  User authentication types: password
  Account disabled: False
  Preserved user: False
  Member of groups: ipausers
  ipauniqueid: 81c42f04-ef4e-11ec-bdf9-5254004d77d3
  krbextradata: AAIDRa5icm9vdC9hZG1pbkBIVzM4Lk9UVVMA
  krblastpwdchange: 20220618213459Z
  mepmanagedentry: cn=nomad,cn=groups,cn=accounts,dc=hw38,dc=otus
  objectclass: top, person, organizationalperson, inetorgperson, inetuser, posixaccount, krbprincipalaux, krbticketpolicyaux, ipaobject, ipasshuser, ipauserauthtypeclass, ipaSshGroupOfPubKeys,
               mepOriginEntry
----------------------------
Number of entries returned 2
----------------------------

```
</details>

<details>
<summary>IPA Client</summary>

```
[vagrant@ipaclient ~]$ echo "Otus2022" | kinit admin
Password for admin@HW38.OTUS:
[vagrant@ipaclient ~]$ ipa user-find --all
---------------
2 users matched
---------------
  dn: uid=admin,cn=users,cn=accounts,dc=hw38,dc=otus
  User login: admin
  Last name: Administrator
  Full name: Administrator
  Home directory: /home/admin
  GECOS: Administrator
  Login shell: /bin/bash
  Principal alias: admin@HW38.OTUS
  User password expiration: 20220916213310Z
  UID: 456000000
  GID: 456000000
  Account disabled: False
  Preserved user: False
  Member of groups: admins, trust admins
  Member of Sudo rule: OTUS
  ipauniqueid: a698f2fc-ef4d-11ec-8a9e-5254004d77d3
  krbextradata: AAKWRK5icm9vdC9hZG1pbkBIVzM4Lk9UVVMA
  krblastpwdchange: 20220618213310Z
  objectclass: top, person, posixaccount, krbprincipalaux, krbticketpolicyaux, inetuser, ipaobject, ipasshuser, ipaSshGroupOfPubKeys

  dn: uid=nomad,cn=users,cn=accounts,dc=hw38,dc=otus
  User login: nomad
  First name: Otus
  Last name: Otusov
  Full name: Otus Otusov
  Display name: Otus Otusov
  Initials: OO
  Home directory: /home/nomad
  GECOS: Otus Otusov
  Login shell: /bin/bash
  Principal name: nomad@HW38.OTUS
  Principal alias: nomad@HW38.OTUS
  User password expiration: 20220618213459Z
  Email address: ootusov@otus.ru
  UID: 456000001
  GID: 456000001
  User authentication types: password
  Account disabled: False
  Preserved user: False
  Member of groups: ipausers
  ipauniqueid: 81c42f04-ef4e-11ec-bdf9-5254004d77d3
  krbextradata: AAIDRa5icm9vdC9hZG1pbkBIVzM4Lk9UVVMA
  krblastpwdchange: 20220618213459Z
  mepmanagedentry: cn=nomad,cn=groups,cn=accounts,dc=hw38,dc=otus
  objectclass: top, person, organizationalperson, inetorgperson, inetuser, posixaccount, krbprincipalaux, krbticketpolicyaux, ipaobject, ipasshuser, ipauserauthtypeclass, ipaSshGroupOfPubKeys, mepOriginEntry
----------------------------
Number of entries returned 2
----------------------------

```
</details>


