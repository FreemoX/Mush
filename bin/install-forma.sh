#!/bin/bash

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

desiredphpversion="7.0"

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
    mushApacheComSummary 
    echo ""
    read -p "Press any key to continue" i
    i=""
    mushNewLine 3
    clear
    echo "You will now be guided through the secure"
    echo "database installation for Marsudo a2ensite forma.conf"
    sudo a2enmod rewrite
    sudo systemctl restart apache2.service
    sudo systemctl restart mariadb.service
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
}

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

mushLAMPinstall

echo ""
echo "Use 'sudo nano /etc/php/$desiredphpversion/apache2/php.ini'"
echo "to configure apache2 to the following settings:"
echo "file_uploads = On"
echo "allow_url_fopen = On"
echo "short_open_tag = On"
echo "memory_limit = 256"
echo "upload_max_filesize = 100M"
echo "max_execution_time = 360"
echo ""
mushPrompt "Press 'ENTER' when the changes have been made"
sudo systemctl restart apache2.service
mysql -u formauser -p $mysqlsecureinstallationdatabasepass << EOF
CREATE DATABASE forma CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'formauser'@'localhost' IDENTIFIED BY 'Algebra2154';
GRANT ALL ON forma.* TO 'formauser'@'localhost' IDENTIFIED BY 'Algebra2154' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
EOF
cd /tmp
wget -c "https://sourceforge.net/projects/forma/files/latest/download?source=files" -O formalms-v2.0.zip
cat > Readme.txt << EOF
If you can read this, it means that the Forma installation script has successfully
placed the required files in this folder, and most likely has already removed them.

Take care.
EOF
sudo unzip -d /var/www/html/forma /tmp/formalms-v2.0.zip
sudo chown -R www-data:www-data /var/www/html/forma/
sudo chmod -R 755 /var/www/html/forma/
cat > /etc/apache2/sites-available/forma.cnf << EOF
<VirtualHost *:80>
     ServerAdmin fr@norditc.no
     DocumentRoot /var/www/html/forma/formalms
     ServerName example.com
     ServerAlias www.example.com

     <Directory /var/www/html/forma/formalms/>
          Options FollowSymlinks
          AllowOverride All
          Require all granted
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined
    
     <Directory /var/www/html/forma/formalms/>
            RewriteEngine on
            RewriteBase /
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*) index.php [PT,L]
    </Directory>
</VirtualHost>
EOF
sudo a2ensite forma.conf
sudo a2enmod rewrite
sudo systemctl restart apache2.service