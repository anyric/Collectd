#!/bin/bash

install_tools() {
  echo "Installing tools"
  sudo apt-get update && \
  sudo apt-get install -y sysstat collectd \
    librrds-perl libjson-perl libhtml-parser-perl
}

configure_sysstat() {
  echo "Configuring sysstat"
  sudo rm -rf /etc/default/sysstat
  sudo cp sysstat.conf /etc/default/sysstat
}

configure_collectd() {
  echo "Configuring Collectd"
  sudo service collectd start

  cd /usr/local/
  sudo git clone https://github.com/httpdss/collectd-web.git
  cd collectd-web/
  chmod +x cgi-bin/graphdefs.cgi
}

configure_appache2() {
  echo "Configuring apache2"
  sudo cat apache2.conf >> /etc/apache2/sites-available/000-default.conf

  sudo a2enmod cgi cgid
  sudo service apache2 restart
}

start_cgi_server() {
  echo "Starting CGI Server"
  cd collectd-web/
  sudo ./runserver.py &
}
main(){
  install_tools
  configure_sysstat
  configure_collectd
  #configure_appache2
  start_cgi_server
}

main "$@"