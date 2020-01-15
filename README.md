# Easy-LDAP
Понятный, быстрый поиск в домене через LDAP

## Установка

Качаем, запускаем install.sh
```bash
git clone https://github.com/AnotherProksY/Easy-LDAP.git
cd Easy-LDAP/
bash install.sh
```

## Использование

```bash
ezldap -d 'Surname Firstname' -a 'attribute_1 attribute_2'
ezldap -n 'Surname Firstname' -a 'attribute_1 attribute_2'
ezldap -l 'user_name' -a 'attribute_1 attribute_2'

ezldap -g 'group_name' -a 'attribute_1 attribute_2'

ezldap -m

#help
ezldap -h
```
