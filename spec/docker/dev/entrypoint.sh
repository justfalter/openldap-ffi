#!/bin/bash

[ -z "$LDAPSERVER_HOSTNAME" ] && echo "Need to set LDAPSERVER_HOSTNAME" && exit 1;
[ -z "$LDAPSERVER_USER" ] && echo "Need to set LDAPSERVER_USER" && exit 1;
[ -z "$LDAPSERVER_PASS" ] && echo "Need to set LDAPSERVER_PASS" && exit 1;
[ -z "$LDAPSERVER_URL" ] && echo "Need to set LDAPSERVER_URL" && exit 1;
[ -z "$LDAPSERVER_TLS_URL" ] && echo "Need to set LDAPSERVER_TLS_URL" && exit 1;

exec "$@"
