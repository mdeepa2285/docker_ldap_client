FROM ubuntu:16.04
maintainer Deepa M <matavalam.deepa@gmail.com>
run  apt-get update -y && apt-get install -y nano openssh-server openssh-client sudo 
run DEBIAN_FRONTEND=noninteractive apt-get install libpam-ldap nscd -y
copy start.sh /root/start.sh
copy manual-ldap-config /usr/local/bin/manual-ldap-config
run chmod 700 /usr/local/bin/manual-ldap-config
run chown root:root /usr/local/bin/manual-ldap-config
run chmod 777 /root/start.sh
run export DEBIAN_FRONTEND=gtk
entrypoint "/root/start.sh"
