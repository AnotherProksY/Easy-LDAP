# Easy-LDAP
Понятный, быстрый поиск в домене через LDAP

## Установка

Качаем, делаем файл исполняемым
```bash
git clone https://github.com/AnotherProksY/Easy-LDAP.git
cd Easy-LDAP/
mv ezldap.sh /usr/local/bin/;chmod +x ezldap.sh
```
Если нет папки bin
```bash
mkdir ~/bin

#Если есть, пропускаем 
```

Экспортируем файл
```bash
nano ~/.bash_profile

#вставляем это
export PATH=~/bin:$PATH
alias ezldap='ezldap.sh'

#сохраняем
```

## Использование

```bash
ezldap -n 'Surname Firstname' -a 'attribute_1 attribute_2'
ezldap -l 'user_name' -a 'attribute_1 attribute_2'

#или просто
ezldap -h
```
