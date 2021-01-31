#!/bin/bash

#########################INSTALL###########################
if [ ! -d "$HOME/bin" ]; then
  echo "Creating ~/bin"
  mkdir $HOME/bin
  sleep 1
  echo ""
fi

FILE=~/.bash_profile
if test -f "$FILE"; then
  if ! grep -qe '$HOME/bin\|~/bin' "$FILE"; then
    echo 'Adding ~/bin to $PATH .bash_profile'
    cat assets/bash.md >> ~/.bash_profile
    source ~/.bash_profile
    sleep 1
    echo ""
  fi
else
  echo "Creating ~/.bash_profile .."
  touch ~/.bash_profile
  echo 'Adding ~/bin to $PATH .bash_profile'
  cat assets/bash.md >> ~/.bash_profile
  source ~/.bash_profile
  sleep 1
  echo ""
fi

APP_FILE=~/bin/ezldap
if ! test -f "$APP_FILE"; then
  echo "Do you want to copy file or create symlink ?" 
  read -p "'1 copy' || '2 symlink' [1/2]: " answer
  if [ $answer == "1" ]; then
    echo "Copying ezldap to ~/bin/"
    cp ezldap ~/bin/;sudo chmod +x ~/bin/ezldap
  else
    echo "Creating symlink for ezldap to ~/bin/"
    ln -s "$PWD/ezldap" ~/bin;sudo chmod +x ~/bin/ezldap
  fi
  sleep 1
  echo ""
fi
###########################END#############################


#########################CONFIG############################
if ! [ $(id -u) = 0 ]; then
  current_user=$USER
else
  current_user=$SUDO_USER
fi

CONFIG_FILE=/etc/ezldap/ezldap.conf
if ! test -f "$CONFIG_FILE"; then
  echo "Starting to create your config file.."
  echo "Config file will be located in /etc/ezldap/"
  sleep 2
  sudo mkdir /etc/ezldap
  sudo cp assets/ezldap.conf /etc/ezldap/
  sudo "${EDITOR:-nano}" /etc/ezldap/ezldap.conf
  sudo chmod go-r /etc/ezldap/ezldap.conf
  sudo chown $current_user /etc/ezldap/ezldap.conf
fi

INSTALL_FILE=/etc/ezldap/install.sh
if ! test -f "$INSTALL_FILE"; then
  echo "Copying install.sh to /etc/ezldap.."
  sleep 1
  sudo cp install.sh /etc/ezldap/
  sudo chmod 700 /etc/ezldap/install.sh
  sudo chown $current_user /etc/ezldap/install.sh
  exit 1
fi

exit 1
###########################END#############################
