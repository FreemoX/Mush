#!/bin/bash
sudo apt update && sudo apt upgrade && sudo apt install curl nginx -y && wait
cd /tmp
curl -O http://vestacp.com/pub/vst-install.sh && wait
sduo bash ./vst-install.sh && wait && sleep 5
sudo ufw enable
sudo ufw allow 8083
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo systemctl restart nginx
sudo systemctl enable nginx
echo ""
echo "Testing localhost https at port 8083"
curl -Is https://localhost:8083 | head -n 1 && wait
echo ""
echo "Testing localhost http at port 8083"
curl -Is http://localhost:8083 | head -n 1 && wait
firefox -new-tab "https://localhost:8083"
# echo << ENDOFECHO
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
# ENDOFECHO