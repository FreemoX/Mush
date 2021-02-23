#!/bin/bash
grep VERSION_ID= /etc/os-release
echo "Highest release compatible: 18.10"
echo "We recommend using Ubuntu 18.04 LTS"
echo ""
read -s -p "Press any key to continue, or 'CTRL + C' to abort"
sudo apt update && sudo apt upgrade && sudo apt install curl nginx -y && wait && sleep 1
cd /tmp
sudo curl -O http://vestacp.com/pub/vst-install.sh && wait && sleep 1
#sduo bash ./vst-install.sh && wait && sleep 5
bash vst-install.sh --nginx yes --apache yes --phpfpm no --named no --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim yes --dovecot yes --spamassassin yes --clamav yes --softaculous yes --mysql yes --postgresql no --hostname localhost --email fr@norditc.no --password Algebra2154 && wait && sleep 5
sudo ufw enable && wait
sudo ufw allow 8083 && wait
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS' && wait && sleep 1
sudo systemctl restart nginx && wait && sleep 2
sudo systemctl enable nginx && wait
echo ""
echo "Testing localhost https at port 8083"
curl -Is https://localhost:8083 | head -n 1 && wait
echo ""
echo "Testing localhost http at port 8083"
curl -Is http://localhost:8083 | head -n 1 && wait
firefox -new-tab "https://localhost:8083"
# 
#                                    _,,---.)\__
#                                  ,'.          ""`.
#                                 f.:               \
#                              ,-.|:  ,-.       ,-.  Y-.
#                      ,-.    f , \. /:  \   . /     | j
#                     f.  Y   `.`.       _`. ,'_     |f
#                     |:  |     ) )      "`    "`    |'
#                     l:. l    ( '          --.      j
#                      Y:  Y_,--.Y:         __      (
#                   ,-.|  ,'.::..):..    ,'"-'Y.     Y
#                  f:.           \ ::.  '"'`--`      j
#                  j::            Y-.__        __,,-'___
#                 f;\::.          |    ``""""''__(""'_,.`--.   ,--.
#                 l:::::...       j--.       ,'.. `"'       Y-'.:::)
#                  `-..::::::_,,-'   :).     `--'(::..     ,j..::--(
#                      f`"""'.  .  )-(:.      .:::`---\:.-'Y;:::::::Y
#                      j:::::::::..   Y:        ..:::::`;_,;;;::::::j
#                     f::;;;;;::::::. j:           ...::::\;;:::_,,'
#                     l;;::::::::: _,;:       (.,     .....Y::."\
#                      Y;;;::::_,-';::..                   |:::. Y
#                      l;;;;;:::`-;;;::....                j;;::.|
#                       `;;;;;;;;;:);;;;:::::...          /\;;;;:j
#                         "`------'-.;;;;::::::::...._,-'"  `---'
#                                     ``"""""""""""''