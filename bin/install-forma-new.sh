#!/bin/bash

ses() {
    sudo systemctl stop $1.service
    sudo systemctl enable $1.service
    sudo systemctl start $1.service
    echo "$1 has been restarted and enabled"
}

installphp() {
    sudo apt install \
    $1 libapache2-mod-$1 $1-common $1-mysql $1-gmp $1-ldap $1-curl $1-intl $1-mbstring $1-xmlrpc $1-gd $1-bcmath $1-xml $1-cli $1-zip
}

updatePHPini() {
    sudo sed -i 's/file_uploads = /file_uploads = On #/' /etc/php/$1/apache2/php.ini
    sudo sed -i 's/max_execution_time = /max_execution_time = 360 #/' /etc/php/$1/apache2/php.ini
    sudo sed -i 's/allow_url_fopen = /allow_url_fopen = On #/' /etc/php/$1/apache2/php.ini
    sudo sed -i 's/short_open_tag = /short_open_tag = On #/' /etc/php/$1/apache2/php.ini
    sudo sed -i 's/memory_limit = /memore_limit = 256M #/' /etc/php/$1/apache2/php.ini
    sudo sed -i 's/upload_max_filesize = /upload_max_filesize = 100M #/' /etc/php/$1/apache2/php.ini
}

sudo apt update
sudo apt install apache2 -y
ses apache2
sudo apt install mariadb-server mariadb-client -y
ses mariadb
sudo mysql_secure_installation
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
installphp php7.0
updatePHPini 7.0
sudo systemctl restart apache2.service
sudo mysql <<EOF 2> /dev/null CREATE DATABASE forma CHARACTER SET utf8 COLLATE utf8_general_ci;
EOF
[ $? -eq 0 ] && echo "Databasen forma ble opprettet" || echo "Databasen forma eksisterer allerede"
sudo mysql <<EOF 2> /dev/null CREATE USER 'formalmsuser'@'localhost' IDENTIFIED BY 'Algebra2154';
EOF
[ $? -eq 0 ] && echo "Opprettet brukeren formalmsuser tilgjengelig fra localhost" || echo "Brukeren formalmsuser eksisterer allerede"
sudo mysql <<EOF 2> /dev/null CREATE USER 'extformalmsuser'@'%' IDENTIFIED BY 'Algebra2154';
EOF
[ $? -eq 0 ] && echo "Opprettet brukeren extformalmsuser tilgjengelig fra over alt" || echo "Brukeren extformalmsuser eksisterer allerede"
sudo mysql <<EOF 2> /dev/null GRANT ALL ON forma.* TO 'formalmsuser'@'localhost' IDENTIFIED BY 'Algebra2154' WITH GRANT OPTION;
EOF
[ $? -eq 0 ] && echo "Brukeren formalmsuser (lokal) har fått tilgang til databasen forma" || echo "Brukeren formalmsuser (lokal) fikk ikke tilgang til databasen forma"
sudo mysql <<EOF 2> /dev/null GRANT ALL ON forma.* TO 'formalmsuser'@'%' IDENTIFIED BY 'Algebra2154' WITH GRANT OPTION;
EOF
[ $? -eq 0 ] && echo "Brukeren extformalmsuser (ekstern) har fått tilgang til databasen forma" || echo "Brukeren extformalmsuser (ekstern) fikk ikke tilgang til databasen forma"
sudo mysql <<EOF 2> /dev/null FLUSH PRIVIEGES;
EOF
sudo mysql <<EOF 2> /dev/null EXIT;
EOF
cd /tmp
sudo apt install wget -y
wget -c "https://sourceforge.net/projects/forma/files/latest/download?source=files" -O formalms-v2.0.zip
sudo apt install unzip -y
sudo unzip -d /var/www/ /tmp/formalms-v2.0.zip
sudo cp /var/www/formalms/* /var/www/html/ -r
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
cat > /etc/apache2/sites-available/forma.cnf << EOF
<VirtualHost *:80>
     ServerAdmin fr@norditc.no
     DocumentRoot /var/www/html
     ServerName lms.norditc.no
     ServerAlias www.lms.norditc.no

     <Directory /var/www/html/>
          Options FollowSymlinks
          AllowOverride All
          Require all granted
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined
    
     <Directory /var/www/html/>
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
echo ""
echo "Forma LMS er nå tilgjengelig på følgende IP-adresser:"
ip a | grep "inet 192."
echo ""
echo ""
echo "Husk å last ned config.php filen FØR du går videre!"
echo "Den må også lastes opp til /var/www/html mappen." && sleep 10
echo ""
read -p "Trykk en tast for å fjerne installasjonsmappen   " i
echo "Er du helt sikker på at du har fullført installasjonen,"
echo "og at du er klar for å fjerne installasjonsmappen?"
read -p "Ja, jeg er klar. Fjern installasjonsmappen! "
echo ""
sudo cp /var/www/html/install /home/norditc/formalmsinstall -r
sudo rm /var/www/html/install -r
echo "Installasjonsmappen er nå flyttet til hjemmappen for norditc brukeren, just in case"
exit