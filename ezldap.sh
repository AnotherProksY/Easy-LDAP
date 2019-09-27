#!/bin/bash

#Create config----------------
function CONFIG {
cat > /etc/ezldap.conf <<EOF
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
password="your_pass"

# Base DC
search_base="dc=super,dc=domain,dc=com"

####################################
EOF

"${EDITOR:-nano}" /etc/ezldap.conf

exit 1
}
#----------------------------

#Check config-----------------
FILE=/etc/ezldap.conf
if test -f "$FILE";
then
    source /etc/ezldap.conf
else
    CONFIG
fi
#-----------------------------

#Get file name---------------
_self="${0##*/}"
#----------------------------

#Get user name---------------
if ! [ $(id -u) = 0 ];
then
    current_user=$USER
else
    current_user=$SUDO_USER
fi
#----------------------------

#Help------------------------
function HELP {
    echo "Options:"
    echo ""
    echo "-h                        show help"
    echo "-n                        search user by 'CN'"
    echo "-l                        search user by 'sAMAccountName'"
    echo "-g                        search group by 'CN'"
    echo "-a                        add additional attribute's"
    echo ""
    echo "Usage:"
    echo ""
    echo "To find user"
    echo "$_self -n 'Surname Firstname' -a 'attribute_1 attribute_2'"
    echo "$_self -l '$current_user' -a 'attribute_1 attribute_2'"
    echo ""
    echo "To find group"
    echo "$_self -g 'any_group' -a 'attribute_1 attribute_2'"
    echo ""
    exit 1
}
#----------------------------

#Flag options----------------
while getopts :n:l:g:a:h flag; do
    case $flag in
        n) NAME=${OPTARG} ;;
        l) LOGIN=${OPTARG} ;;
        g) GROUP=${OPTARG} ;;
        a) ATTRIBUTE=${OPTARG} ;;
        h) HELP ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
            HELP
            ;;
    esac
done

shift $((OPTIND-1))
#----------------------------

#Filter options--------------
if [ -z "$GROUP" ]
then
    filter="(&(objectCategory=Person)(cn=*$NAME)(sAMAccountName=*$LOGIN))"
    basic_attribute="name sAMAccountName mail physicalDeliveryOfficeName telephoneNumber birthDate"
else
    filter="(&(objectClass=group)(cn=*$GROUP))"
    basic_attribute="member distinguishedName name sAMAccountName managedBy mail mailNickname description"
fi
#----------------------------

ldapsearch \
-H ldaps://$domain \
-D "$username" \
-w "$password" \
-b "$search_base" \
$filter \
$basic_attribute \
$ATTRIBUTE \
| egrep -v "^# .+" | egrep -v "^ref: .+"