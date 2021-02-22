#!/bin/bash
#
mushVersionL=0
mushVersionM=0
mushVersionS=1
mushVersion="$mushVersionL.$mushVersionM.$mushVersionS"

mushEchoVersion() {
    echo ""
    echo "This script uses the mush framework."
    echo "Made by Franz Rolfsvaag."
    echo "Running version: Mush $mushVersion"
    echo ""
}

if [ $# -eq 0 ]; then
    echo "No arguments made."
elif [ $1 == "--help" ]; then
    mushEchoVersion
    echo "Installed commands:"
    echo ""
    echo "mushNewLine <int>                 # Echoes int (1 - 100) new lines"
    echo "mushHLine                         # Echoes a horizontal line"
    echo "mushHDivider                      # Echoes a horizontal divider line"
    echo "mushOSUpgrade                     # Updates the system"
    echo "mushPublicIP                      # Gathers the public IPv4"
    echo "mushZTJoin <Network-ID>           # Join ZeroTier Network"
    echo "mushLAMPinstall                   # Installs the LAMP stack"
    exit 1
elif [ $1 != "--help" ]; then
    echo "Invalid argument."
    echo "Available arguments are: --help"
fi

#                                                |
# This script functions as a shell framework.    |
# To include this framework into a script,       |
# add "source <path>/mu.sh" below the shebang.   |
#
# Github URL:
# https://github.com/FreemoX/Mush-framework
# 
# Made by Franz Rolfsvaag
# Released under the GPLv3 license
# Tested with Ubuntu 20.04
# 
# Mu.sh is a framework delivering pre-made
# functions into your scripts, providing
# frequently used operations with a single
# function call.
#
# - - - - - - - - - - - - - - - - - - - - - - - -
#
# FUNCTIONS LIST
# All functions start with the "mush" prefix
# eg "mushNewLine 4"
#
#       Function Name           #       Function Description
#
# NewLine <int>                 # Echoes int (1 - 100) new lines
# HLine                         # Echoes a horizontal line
# HDivider                      # Echoes a horizontal divider line
# OSUpgrade                     # Updates the system
# PublicIP                      # Gathers the public IPv4
# ZTJoin <Network-ID>           # Join ZeroTier Network
# LAMPinstall                   # Installs the LAMP stack
#
# - - - - - - - - - - - - - - - - - - - - - - - -

mushPrompt() {
    if [ $# -eq 0 ]; then
        echo ""
        read -p "Press 'ENTER' to continue" && REPLY=""
        echo ""
    elif [ $# -gt 0 ]; then
        echo ""
        echo "Please enclose your promt in quotes: \"\""
        echo ""
        exit 1
    else
        read -p "$1" i
    fi
}

mushNewLine() {
    nlines=$1
    TELLER=0
    if [[ "$nlines" -lt 101 && "$nlines" -gt 0 ]]; then
        while [ $TELLER -lt $nlines ]; do
            echo ""
            let TELLER=TELLER+1
        done
    elif [ "$nlines" -gt 100 ]; then
        echo ""
        echo "Too many lines"
        echo "Keep it at max 100"
        echo ""
    else
        echo ""
        echo "Not a valid integer"
        echo "Valid values: 1-100"
        echo ""
    fi
}

mushHLine() {
    echo "- - - - - - - - - - - - - - - - - - - - - - - - -"
}

mushHDivider(){
    mushNewLine 1
    mushHLine
    mushNewLine 1
}

mushOSUpgrade() {
    sudo apt update && wait
    sudo apt upgrade -y && wait
    mushNewLine 2
    echo "System updated"
    mushNewLine 2
}

mushPublicIP() {
    dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'
}

mushZTJoin() {
    echo ""
    echo "Downloading the ZeroTier client"
    echo ""
    curl -s https://install.zerotier.com | sudo bash && wait
    echo ""
    if [ $1 -eq "" ]; then
        echo "Please input a valid network ID"
        break
    else
        echo "Joining network $1"
        sudo zerotier-cli join $1
    fi
}

# More advanced functions below

mushLAMPinstall() {

    mushApacheComSummary() {
        mushHDivider
        echo "Use the following commands to control Apache2"
        mushNewLine 1
        echo "To stop the Apache Webserver"
        echo "sudo systemctl stop apache2.service"
        mushHLine
        echo "To start the Apache Webserver"
        echo "sudo systemctl start apache2.service"
        mushHLine
        echo "To restart the Apache Webserver"
        echo "sudo systemctl restart apache2.service"
        mushHLine
        echo "To auto-start the Apache Webserver"
        echo "sudo systemctl enable apache2.service"
    }

    mushMySQLComSummary() {
        mushHDivider
        echo "Use the following commands to control MySQL - MariaDB"
        mushNewLine 1
        echo "To stop the MySQL - MariaDB Database"
        echo "sudo systemctl stop mariadb.service"
        mushHLine
        echo "To start the MySQL - MariaDB Database"
        echo "sudo systemctl start mariadb.service"
        mushHLine
        echo "To restart the MySQL - MariaDB Database"
        echo "sudo systemctl restart mariadb.service"
        mushHLine
        echo "To auto-start the MySQL - MariaDB Database"
        echo "sudo systemctl enable mariadb.service"
    }

    mushNewLine 5
    echo "Initiating LAMP-stack installation"
    echo ""
    echo "L - Linux"
    echo "A - Apache Webserver"
    echo "M - MySQL Database"
    echo "P - PHP functionality"
    echo ""
    echo "Only run this on a new installation!"
    echo ""
    echo "To abort, press \"Q\""
    read -p "Press \"Y\" to continue" i
    if [[ $i == "Q" || $i == "q" ]]; then
        exit 1
    elif [[ $i == "Y" || $i == "y" ]]; then
        echo ""
    else
        echo "Invalid key. Try again."
        echo ""
        echo "To abort, press \"Q\""
        read -p "Press \"Y\" to continue" i
        if [[ $i == "Q" || $i == "q" ]]; then
            exit 1
        elif [[ $i == "Y" || $i == "y" ]]; then
        echo ""
        else
            echo "Fine, we'll abort"
            sleep 1
            exit 1
        fi
    fi
    i=""
    mushNewLine 3
    echo "Updating repositories"
    mushNewLine 2
    sudo apt update
    mushNewLine 3
    echo "Installing apache2"
    mushNewLine 3
    sudo apt install apache2 -y
    mushNewLine 3
    mushApacheComSummary
    echo ""
    read -p "Press any key to continue" i
    i=""
    mushNewLine 3
    echo "Installing MySQL - MariaDB Database"
    echo ""
    sudo apt install mariadb-server mariadb-client -y
    mushNewLine 3
    mushApacheComSummary echo ""
    read -p "Press any key to continue" i
    i=""
    mushNewLine 3
    clear
    echo "You will now be guided through the secure"
    echo "database installation for MariaDB."
    echo ""
    echo "Press \"Y\" on any questions asked."
    echo "Please remember the password you will input."
    echo "You will need this later."
    echo ""
    echo "After the installation, we will ask you for the"
    echo "database password, so we can remember you at"
    echo "the installation summary at the end."
    sleep 20
    sudo mysql_secure_installation && wait
    clear
    echo "Please input the database password you entered"
    echo "in the secure installation window:"
    echo ""
    read -p 'Database Password: ' mysqlsecureinstallationdatabasepass
    echo ""
    echo "Thank you. We will show your password at the end"
    echo "of this installation script."
    sleep 5
    clear
    echo "Installing PHP"
    echo ""
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/PHP
    sudo apt update
    clear
    echo "Which PHP version would you like to install?"
    echo "Only write the version number and press ENTER"
    echo ""
    echo "eg: \"8.0\" will install PHP 8.0"
    mushNewLine 3
    read -p 'I want to install PHP version: ' desiredphpversion
    clear
    echo "Ok, proceeding to install PHP version $desiredphpversion"
    sudo apt install \
    php$desiredphpversion \
    libapache2-mod-php$desiredphpversion \
    php$desiredphpversion-common \
    php$desiredphpversion-mysql \
    php$desiredphpversion-gmp \
    php$desiredphpversion-ldap \
    php$desiredphpversion-curl \
    php$desiredphpversion-intl \
    php$desiredphpversion-mbstring \
    php$desiredphpversion-xmlrpc \
    php$desiredphpversion-gd \
    php$desiredphpversion-bcmath \
    php$desiredphpversion-xml \
    php$desiredphpversion-cli \
    php$desiredphpversion-zip
    mushNewLine 5
    echo "PHP $desiredphpversion is now installed ..."
    sleep 5
    clear
    echo "Cleaning up ..."
    mushNewLine 5
    sudo a2enmod rewrite
    sudo systemctl restart apache2.service
    clear
    echo "LAMP-stack installation complete."
    echo "Here is the installation summary:"
    mushNewLine 2
    echo "Apache Webserver version:"
    apachectl -v | grep Apache/*.*.*
    mushApacheComSummary
    echo ""
    echo "MySQL - MariaDB Database Version:"
    mysql --version | grep "Ver *.*.*-*ubuntu"
    echo "Database password: $mysqlsecureinstallationdatabasepass"
    mushMySQLComSummary
    echo ""
    echo "PHP Version installed:"
    php --version | grep "PHP *.*.*(cli)"
    mushNewLine 5
    echo "Remember your database password!"
    read -p "Press any key to exit" i
    i=""
    mysqlsecureinstallationdatabasepass=""
    desiredphpversion=""
}

mushNextstall() {
    echo ""
    echo "Grabbing Nextstall"
    sleep 1
    source <(curl -s https://raw.githubusercontent.com/FreemoX/Nextstall/main/Nextstall.sh)
}

# pre-EOF ######################################################################################

echo ""
mushEchoVersion
echo "[0] - Exit"
echo ""
echo "[1] - Install LAMP Stack      # Self-explanatory"
echo "[2] - Run Nextstall           # Install Nextcloud"
echo "[9] - Run the test"
echo ""
read -n 1 -s -p 'Select a process to run'
echo ""
echo "Running process [$REPLY]"
if [ $REPLY == "1" ]; then
    mushLAMPinstall
elif [ $REPLY == "2" ]; then
    mushNextstall && wait
elif [ $REPLY == "9" ]; then
    mushPromt
elif [ $REPLY == "0" ]; then
    echo ""
    echo "Exiting"
    sleep 1
    exit 1
fi