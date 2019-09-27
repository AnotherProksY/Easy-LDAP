#!/bin/bash

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
    echo "bash $_self -n 'Surname Firstname' -a 'attribute_1 attribute_2'"
    echo "bash $_self -l '$current_user' -a 'attribute_1 attribute_2'"
    echo ""
    echo "To find group"
    echo "bash $_self -g 'any_group' -a 'attribute_1 attribute_2'"
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
-H ldaps://domain.controller.com \
-D "user_name@domain.com" \
-W \
-b "dc=domain,dc=controller,dc=com" \
$filter \
$basic_attribute \
$ATTRIBUTE \
| egrep -v "^# .+" | egrep -v "^ref: .+"