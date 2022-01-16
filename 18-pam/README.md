# Домашнее задание. PAM

    Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников

## Описание каталогов и файлов в репозитории
- Vagrantfile - ВМ
- init_pam.sh - Настройка PAM

## Развертывание ВМ
```bash
vagrant up
```

## Проверка работоспособности
```bash
vagrant ssh
ssh dauser@localhost
```

В случае, если пароль введен верно, то выводится сообщение:
dauser@localhost's password: 
Authentication failed.
