#!/bin/bash

#########################CONFIG############################
source /etc/ezldap/ezldap.conf
###########################END#############################


###########################LDAP############################
LDAP_TYPE="search"

#LDAP query------------------
function LDAP_QUERY {
    if [ $LDAP_TYPE == "search" ]
    then
        #Filter options---------------
        if [ -z "$GROUP" ]
        then
            filter="(&(objectCategory=Person)(cn=*$NAME)(sAMAccountName=*$LOGIN))"
            basic_attribute="name displayName sAMAccountName mail physicalDeliveryOfficeName telephoneNumber birthDate"
        else
            filter="(&(objectClass=group)(cn=*$GROUP))"
            basic_attribute="member distinguishedName name sAMAccountName managedBy mail mailNickname description"
        fi
        #-----------------------------

        ldapsearch \
        -H ldaps://$domain \
        -D "$username" \
        -W \
        -b "$search_base" \
        $filter \
        $basic_attribute \
        $ATTRIBUTE \
        | egrep -v "^# .+" | egrep -v "^ref: .+" \
        | perl -MMIME::Base64 -MEncode=decode -n -00 -e 's/\n 
+//g;s/(?<=:: )(\S+)/decode("UTF-8",decode_base64($1))/eg;print'
    else
echo "dn: $group_dn
changetype: modify
$modify_type: member
member: $user_dn" | \
        ldapmodify \
        -H ldaps://$domain \
        -D "$username" \
        -W \
        | egrep -v "^# .+" | egrep -v "^ref: .+"
    fi
}
#----------------------------

#Modify----------------------
function MODIFY {
    read -p "'add' or 'delete' user from group: " modify_type
    read -p "Copy 'DN' group attribute and paste here: " group_dn
    read -p "Copy 'DN' user attribute and paste here: " user_dn
    echo ""
    echo ""
    LDAP_TYPE="modify"
    LDAP_QUERY
}
#----------------------------
###########################END#############################


###########################CORE############################
#Help------------------------
function HELP {
    #Get file name----------------
    _self="${0##*/}"
    #-----------------------------
    
    #Get user name----------------
    if ! [ $(id -u) = 0 ];
    then
        current_user=$USER
    else
        current_user=$SUDO_USER
    fi
    #-----------------------------

    echo "Options:"
    echo ""
    echo "-h           show help"
    echo "-n  <name>   search user by 'CN'"
    echo "-l  <login>  search user by 'sAMAccountName'"
    echo "-g  <group>  search group by 'CN'"
    echo "-a  <attr>   add additional attribute's"
    echo "-m           add/delete user from group"
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
    echo "To add/delete user from group"
    echo "$_self -m"
    echo ""
    exit 1
}
#----------------------------

#Flag options----------------
while getopts :n:l:g:a:mh flag; do
    case $flag in
        n) NAME=${OPTARG} ;;
        l) LOGIN=${OPTARG} ;;
        g) GROUP=${OPTARG} ;;
        a) ATTRIBUTE=${OPTARG} ;;
        m) MODIFY ;;
        h) HELP ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
            HELP
            ;;
    esac
done

shift $((OPTIND-1))
#----------------------------
###########################END#############################


###########################MAIN############################
LDAP_QUERY
###########################END#############################