#!/bin/bash

if [ ! -e /etc/ldap-bootstrapped ]; then
echo "configuring lapd-client for first run"

## checking the environment variable for non-interactive ldap-client configuration

if [[ $BASE_DN != "" || $URI != "" || $ROOT_ADDCOUNT != "" || $ROOT_PASSWORD != "" ]]; then

## take ldap backup
cp /etc/ldap.conf /etc/ldap.conf-bak
cat <<EOF > /etc/ldap.conf
base $BASE_DN
uri $URI
ldap_version 3
rootbinddn $ROOT_ADDCOUNT
pam_password md5
pam_filter objectclass=posixAccount
pam_login_attribute uid
EOF

## ldap admin password storing in config file '/etc/ldap.secret'

echo $ROOT_PASSWORD > /etc/ldap.secret
## editing the file '/etc/nsswitch.conf' will allow us to specify that the LDAP credentials should be modified when users issue authentication change commands.

cp /etc/nsswitch.conf /etc/nsswitch.conf-bak
cat <<EOF > /etc/nsswitch.conf
# /etc/nsswitch.conf
#
passwd:         ldap compat
group:          ldap compat
shadow:         ldap compat
hosts:          files dns
networks:       files
protocols:      db files
services:       db files
ethers:         db files
rpc:            db files
netgroup:       nis
EOF

## This will create a home directory on the client machine when an LDAP user logs in who does not have a home directory.
echo "session required    pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
sed -i "s|use_authtok||g" /etc/pam.d/common-password
 else

## interactive configuration for ldap-client
echo -e '\E[32m'"Run 'lets-ldap' for manual configuration of ldap client $A"
 fi
echo "do not remove this file" >> /etc/ldap-bootstrapped
fi

## restarting services

/etc/init.d/ssh restart
/etc/init.d/nscd restart

/bin/bash
