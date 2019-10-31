#!/bin/bash

#########################INSTALL###########################
echo "#Moving ezldap.sh to /usr/local/bin/ and giving execute option"
sudo cp ezldap.sh /usr/local/bin/;sudo chmod +x /usr/local/bin/ezldap.sh
sleep 1
echo ""

if [ ! -d "~/bin" ]; then
    echo "Creating ~/bin"
    mkdir ~/bin
    sleep 1
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
    sleep 1
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
    sleep 1
    echo ""
fi
###########################END#############################


#########################CONFIG############################
if ! [ $(id -u) = 0 ];
then
    current_user=$USER
else
    current_user=$SUDO_USER
fi

function CONFIG {
echo "Starting to create your config file.."
echo "Config file will be located in /etc/ezldap/"
sleep 2
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
password="auth_password"

# Base DC
search_base="dc=super,dc=domain,dc=com"

####################################
EOF'

sudo "${EDITOR:-nano}" /etc/ezldap/ezldap.conf
sudo chmod go-r /etc/ezldap/ezldap.conf
sudo chown $current_user /etc/ezldap/ezldap.conf

exit 1
}

CONFIG
###########################END#############################