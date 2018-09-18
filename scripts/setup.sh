#!/bin/bash

install_tools() {
  sudo apt-get install -y sysstat collectd git \
    librrds-perl libjson-perl libhtml-parser-perl apache2
}

configure_sysstat() {
  sudo rm -rf /etc/default/sysstat
  sudo cp sysstat.conf /etc/default/sysstat
}

configure_collectd() {
  sudo service collectd start

  cd /var/www/html
  sudo git clone https://github.com/httpdss/collectd-web.git
  sudo chmod +x /var/www/html/collectd-web/cgi-bin/graphdefs.cgi
}

configure_appache2() {
  sudo cat apache2.conf >> /etc/apache2/sites-available/000-default.conf

  sudo a2enmod cgi cgid
  sudo service apache2 restart
}

main(){
  install_tools
  configure_sysstat
  configure_collectd
  configure_appache2
}

main "$@"