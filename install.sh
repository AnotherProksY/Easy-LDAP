#!/bin/bash

#########################INSTALL###########################
_self="${0##*/}"

echo "#Moving $_self to /usr/local/bin/ and giving execute option"
sudo mv ezldap.sh /usr/local/bin/;sudo chmod +x ezldap.sh
echo ""

if [ ! -d "~/bin" ]; then
    echo "Creating ~/bin"
    mkdir ~/bin
    echo ""
fi

FILE=~/.bash_profile
if test -f "$FILE";
then
    echo "Adding options to .bash_profile"
    cat >> ~/.bash_profile <<EOF
    export PATH=~/bin:$PATH
    alias ezldap='ezldap.sh'
EOF
    source ~/.bash_profile
    echo ""
else
    echo "Creating ~/.bash_profile .."
    touch ~/.bash_profile
    echo "Adding options to .bash_profile"
    cat >> ~/.bash_profile <<EOF
    export PATH=~/bin:$PATH
    alias ezldap='ezldap.sh'
EOF
    source ~/.bash_profile
    echo ""
fi
###########################END#############################


#########################CONFIG############################
function CONFIG {
echo "Starting to create your config file.."
echo "Config file will be located in /etc/ezldap/"
sudo mkdir /etc/ezldap
sudo bash -c 'cat > /etc/ezldap/ezldap.conf <<EOF
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
EOF'

sudo "${EDITOR:-nano}" /etc/ezldap/ezldap.conf

exit 1
}
###########################END#############################