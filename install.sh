#!/bin/bash

#########################INSTALL###########################
if [ ! -d "~/bin" ]; then
    echo "Creating ~/bin"
    mkdir ~/bin
    sleep 1
    echo ""
fi

FILE=~/.bash_profile
if test -f "$FILE";
then
    echo 'Adding ~/bin to $PATH .bash_profile'
    cat >> ~/.bash_profile <<EOF
export PATH=~/bin:$PATH
EOF
    source ~/.bash_profile
    sleep 1
    echo ""
else
    echo "Creating ~/.bash_profile .."
    touch ~/.bash_profile
    echo 'Adding ~/bin to $PATH .bash_profile'
    cat >> ~/.bash_profile <<EOF
export PATH=~/bin:$PATH
EOF
    source ~/.bash_profile
    sleep 1
    echo ""
fi

echo "Do you want to copy file or create symlink ?" 
read -p "'1 copy' || '2 symlink' [1/2]: " answer
if [ $answer == "1" ]
then
  echo "Copying ezldap to ~/bin/"
  cp ezldap ~/bin/;sudo chmod +x ~/bin/ezldap
else
  echo "Creating symlink for ezldap to ~/bin/"
  ln -s ezldap ~/bin/;sudo chmod +x ~/bin/ezldap
fi
sleep 1
echo ""
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
