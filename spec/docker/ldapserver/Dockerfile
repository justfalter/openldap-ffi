FROM alpine:3.2
RUN apk add --update openldap openldap-back-bdb openldap-clients

ADD slapd.conf ldapserver.test.crt ldapserver.test.key /etc/openldap/
RUN chmod 600 /etc/openldap/slapd.conf /etc/openldap/ldapserver.test.crt /etc/openldap/ldapserver.test.key
ADD DB_CONFIG /var/lib/openldap/openldap-data/DB_CONFIG

ADD testdata.ldif /tmp/testdata.ldif
RUN slapadd -l /tmp/testdata.ldif
RUN rm -f /tmp/testdata.ldif

RUN chown -R ldap:ldap /etc/openldap /var/lib/openldap

EXPOSE 389 636
CMD [ "/usr/sbin/slapd", "-h", "ldap:/// ldaps:///", "-u", "ldap", "-g", "ldap", "-d", "none" ]
