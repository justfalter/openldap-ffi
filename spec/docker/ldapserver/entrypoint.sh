#!/bin/sh
set -x
BOOTSTRAP_DONE_FILE="${BOOTSTRAP_ROOT}/done"
LDAP_USER="cn=ldaproot,dc=ldapserver,dc=test"
LDAP_PASSWORD=password

if [[ ! -f ${BOOTSTRAP_DONE_FILE} ]]; then
  echo "BOOTSTRAPPING"
  slapadd -l /bootstrap/import.d/testdata.ldif
  chown -R ldap:ldap /var/lib/openldap
  touch ${BOOTSTRAP_DONE_FILE}
fi

#exec /usr/sbin/slapd -f /etc/openldap/slapd.conf -h "ldap:///" -u ldap -g ldap -d 0
exec /usr/sbin/slapd -h "ldap:///" -u ldap -g ldap -d none
