<p align="center">
    <img width="15%" src="assets/ezldap.svg" alt="Banner">
    <p width="15%" style="font-size:45px;font-weight:bold" align="center">Easy-LDAP</p>
</p>
<p align="center">
    <b>Easy to use wrapper for commandline LDAP tools.</b><br />
    <b>Written on Bash Script with Love ❤️</b>
</p>
<p align="center">
    <a href="https://github.com/AnotherProksY/Easy-LDAP/blob/dev/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License Badge">
    </a>
</p>
<br />

---

<br />

## Installation
- Clone:
```bash
git clone https://github.com/AnotherProksY/Easy-LDAP.git
```
- Run `install` script:
```bash
cd Easy-LDAP/
./install
```
- Edit configuration file _(will open automatically in install process)_:
```bash
####################################
#    Config file for Easy-LDAP     #
####################################
# Write your credentials correctly #
#  All info must be specified in   #
#          double quotes           #
####################################

# Your Domain for ldaps://..
domain="super.domain.com"

# Your username for auth
username="user_name@super.domain.com"

# Your pass for auth
password="auth_password"

# Base DC
search_base="dc=super,dc=domain,dc=com"

####################################
```
- Enjoy :)

## Usage examples
- To find user:
```bash
ezldap -d Фазилов Камил -a memberOf department
ezldap -n Fazilov Kamil -a memberOf department
ezldap -l k.fazilov -a memberOf department
ezldap -e k.fazilov@domain.com -a memberOf department
```
- To find group:
```bash
ezldap -g all-users -a objectSid
```
- To add/delete user from group:
```bash
ezldap -m

'add' or 'delete' user from group [add/delete]: add
Copy 'DN' group attribute and paste here: CN=Developers,OU=Users,DC=example,DC=local                                 
Copy 'DN' user attribute and paste here: CN=Fazilov Kamil,OU=Users,DC=example,DC=local

Successfully add!
```

## License and Attribution

Easy-LDAP is licensed under the [MIT License](https://github.com/AnotherProksY/Easy-LDAP/blob/dev/LICENSE), a short and simple permissive license with conditions only requiring preservation of copyright and license notices.
Licensed works, modifications, and larger works may be distributed under different terms and without source code.
