--- 
layout: post_new
title: Failover and Clustering Mirror Node OpenLdap 2.4 on Centos 5.5 (part 2)
date: 2011-02-16 14:44:32
categories: 
- Failover
- CLuster
- Mirror
- Node
- Openldap
- CentOs
---

##READ FIRST
<a href="/2010/09/05/Clustering-Openldap-2.4-dengan-Mirror-Node-Replication-di-CentOs-5.5.html" target="_new">Clustering Openldap 2.4 dengan Mirror Node Replication di Centos 5.5</a>

##Design Sistem:


###Ternate (192.168.11.213) 	= failover
###Halmahera (192.168.11.215)	= node failover
###Morotai (192.168.11.216)	= node failover

<pre>
Ternate (Failover) ---- Halmahera (ldap) --| 
		   |                       | Mirroring
                   ---- Morotai (ldap)  ---|
</pre>

##A. Installasi

###A.1 Barkeley DB 4.8

{% highlight bash %}
# cd /usr/local/src/
# wget -c http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz
# tar -xzvf db-4.8.30.tar.gz
# cd db-4.8.30
# cd build_unix
# ../dist/configure --prefix=/usr/local/BerkeleyDB4.8.30
# make clean
# make
# make install
{% endhighlight %}



###A.2 openldap 2.4

####A.2.1 Non-ssl


{% highlight bash %}
# CPPFLAGS="-I/usr/local/BerkeleyDB4.8.30/include"
# export CPPFLAGS
# LDFLAGS="-L/usr/local/lib -L/usr/local/BerkeleyDB4.8.30/lib -R/usr/local/BerkeleyDB4.8.30/lib"
# export LDFLAGS
# LD_LIBRARY_PATH="/usr/local/BerkeleyDB4.8.30/lib"
# export LD_LIBRARY_PATH
{% endhighlight %}



{% highlight bash %}
# cd /usr/local/src/
# wget -c ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.23.tgz
# ./configure --prefix=/usr/local/openldap2.4
# make depend
# make
# make install
{% endhighlight %}



####A.2.2 with-Openssl

Install openssl:

{% highlight bash %}
# sudo wget -c http://www.openssl.org/source/openssl-1.0.0a.tar.gz
# sudo tar -xzvf openssl-1.0.0a.tar.gz
# cd openssl-1.0.0a
# sudo ./config shared --prefix=/usr/local/openssl/
{% endhighlight %}


Generate server.pem
{% highlight bash %}
# cd /usr/local/openldap/ssl/;
# openssl req -newkey rsa:1024 -x509 -nodes -out server.pem -keyout server.pem -days 3650
{% endhighlight %}


####A.2.3 Install openldap

{% highlight bash %}
# CPPFLAGS="-I/usr/local/BerkeleyDB4.8.30/include -I/usr/local/openssl/include/"
# LDFLAGS="-L/usr/local/lib -L/usr/local/BerkeleyDB4.8.30/lib -R/usr/local/BerkeleyDB4.8.30/lib -L/usr/local/openssl/lib64/"
# LD_LIBRARY_PATH="/usr/local/BerkeleyDB4.8.30/lib"
# export CPPFLAGS
# export LDFLAGS
# export LD_LIBRARY_PATH
{% endhighlight %}

{% highlight bash %}
# cd /usr/local/src/
# wget -c ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.23.tgz
# ./configure --prefix=/usr/local/openldap --with-tls=openssl
# make depend
# make
# make install
{% endhighlight %}



##B. Konfigurasi

###B.1 File conf:


####B.1.1 Non-ssl


{% highlight bash %}
/usr/local/openldap2.4/etc/openldap/slapd.conf
/usr/local/openldap2.4/etc/openldap/ldap.conf
{% endhighlight %}


####B.1.2 with-ssl

{% highlight bash %}
/usr/local/openldap/etc/openldap/slapd.conf
/usr/local/openldap/etc/openldap/ldap.conf
{% endhighlight %}

add to all machine on slapd.conf:

{% highlight bash %}
TLSCipherSuite HIGH:MEDIUM:-SSLv2
TLSCACertificateFile /usr/local/openldap/ssl/server.pem
TLSCertificateFile /usr/local/openldap/ssl/server.pem
TLSCertificateKeyFile /usr/local/openldap/ssl/server.pem
{% endhighlight %}



####B.1.3 NSSswitch

add ldap option on nsswitch.conf to all machine:

{% highlight bash %}
passwd:     files ldap
shadow:     files ldap
group:      files ldap
{% endhighlight %}




###B.2 Konfigurasi Master Failover

TERNATE/192.168.11.213:

####B.2.1 Auth


<script src="https://gist.github.com/1433829.js?file=b21.sh">
</script>




####B.2.2 /etc/ldap.conf:


#Begin
{% highlight bash %}
host  192.168.11.216 192.168.11.215
base dc=finnet-indonesia,dc=com
port 389
timelimit 5
bind_timelimit 2
bind_policy soft
idle_timelimit 3600
nss_initgroups_ignoreusers root,ldap,named,avahi,haldaemon,dbus,radvd,tomcat,radiusd,news,mailman,nscd,gdm,username,rudi
uri ldap://192.168.11.216/ ldap://192.168.11.215/
ssl no
tls_cacertdir /etc/openldap/cacerts
pam_password md5
{% endhighlight %}
#EOF





####B.2.3 PAM:
{% highlight bash %}
/etc/pam.d/system-auth
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        sufficient    pam_ldap.so use_first_pass
auth        required      pam_deny.so

account     required      pam_unix.so broken_shadow
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     default=bad success=ok user_unknown=ignore pam_ldap.so
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    sufficient    pam_ldap.so use_authtok
password    required      pam_deny.so

session required pam_mkhomedir.so skel=/etc/skel/ umask=0022

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     success=1 default=ignore pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
session     optional      pam_ldap.so
{% endhighlight %}





###B.3 SETUP MIRROR NODE

####B.3.1

HALMAHERA/192.168.11.215:


#####B.3.1.1 slapd.conf


user@halmahera ~$ sudo cat /usr/local/openldap2.4/etc/openldap/slapd.conf

{% highlight bash %}
#
# See slapd.conf(5) for details on configuration options.
# This file should NOT be world readable.
#
include         /usr/local/openldap2.4/etc/openldap/schema/core.schema
include         /usr/local/openldap2.4/etc/openldap/schema/corba.schema
include         /usr/local/openldap2.4/etc/openldap/schema/cosine.schema
include         /usr/local/openldap2.4/etc/openldap/schema/nis.schema
include         /usr/local/openldap2.4/etc/openldap/schema/inetorgperson.schema

pidfile         /usr/local/openldap2.4/var/run/slapd.pid
argsfile        /usr/local/openldap2.4/var/run/slapd.args

# Load dynamic backend modules:
 modulepath     /usr/local/openldap2.4

#######################################################################
# BDB database definitions
#######################################################################

database        bdb
suffix          "dc=domain-indonesia,dc=com"
rootdn          "cn=admin,dc=domain-indonesia,dc=com"
# Cleartext passwords, especially for the rootdn, should
# be avoid.  See slappasswd(8) and slapd.conf(5) for details.
# Use of strong authentication encouraged.
rootpw          domainldap
# The database directory MUST exist prior to running slapd AND
# should only be accessible by the slapd and slap tools.
# Mode 700 recommended.
directory       /usr/local/openldap2.4/var/openldap-data
# Indices to maintain

index objectClass,entryCSN,entryUUID    eq,pres
index ou,cn,mail,surname,givenname      eq,pres,sub
index uidNumber,gidNumber,loginShell    eq,pres
index uid,memberUid                     eq,pres,sub
index nisMapName,nisMapEntry            eq,pres,sub


overlay syncprov
syncprov-checkpoint 100 10
syncprov-sessionlog 100

# Global section
serverID    1
# database section

# syncrepl directive
syncrepl        rid=001
                provider=ldap://192.168.11.216
                bindmethod=simple
                binddn="cn=admin,dc=domain-indonesia,dc=com"
                credentials=domainldap
                searchbase="dc=domain-indonesia,dc=com"
                schemachecking=on
                type=refreshAndPersist
                retry="60 +"
mirrormode on

{% endhighlight %}


#####B.3.1.2 /etc/ldap.conf


$ vi /etc/ldap.conf

{% highlight bash %}
#Begin
host 127.0.0.1
base dc=finnet-indonesia,dc=com
timelimit 120
bind_timelimit 120
idle_timelimit 3600
nss_initgroups_ignoreusers root,ldap,named,avahi,haldaemon,dbus,radvd,tomcat,radiusd,news,mailman,nscd,gdm,username,rudi
uri ldap://192.168.11.215/
ssl no
tls_cacertdir /etc/openldap/cacerts
pam_password md5
{% endhighlight %}
#EOF



#####B.3.1.3 Auth

<script src="https://gist.github.com/1433829.js?file=b313.sh">
</script>

#####B.3.1.4 PAM

$ vi /etc/pam.d/system-auth

{% highlight bash %}
PAM (215,216):

#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        sufficient    pam_ldap.so use_first_pass
auth        required      pam_deny.so

session required pam_mkhomedir.so skel=/etc/skel/ umask=0022

account     required      pam_unix.so broken_shadow
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     default=bad success=ok user_unknown=ignore pam_ldap.so
account     required      pam_permit.so

password    requisite     pam_cracklib.so try_first_pass retry=3
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    sufficient    pam_ldap.so use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     success=1 default=ignore pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
session     optional      pam_ldap.so

{% endhighlight %}

####B.3.2

MOROTAI/192.168.11.216:


#####B.3.2.1 slapd.conf

user@morotai ~$ sudo cat /usr/local/openldap2.4/etc/openldap/slapd.conf
{% highlight bash %}
#
# See slapd.conf(5) for details on configuration options.
# This file should NOT be world readable.
#
include         /usr/local/openldap2.4/etc/openldap/schema/core.schema
include         /usr/local/openldap2.4/etc/openldap/schema/corba.schema
include         /usr/local/openldap2.4/etc/openldap/schema/cosine.schema
include         /usr/local/openldap2.4/etc/openldap/schema/nis.schema
include         /usr/local/openldap2.4/etc/openldap/schema/inetorgperson.schema

pidfile         /usr/local/openldap2.4/var/run/slapd.pid
argsfile        /usr/local/openldap2.4/var/run/slapd.args

# Load dynamic backend modules:
 modulepath     /usr/local/openldap2.4

#######################################################################
# BDB database definitions
#######################################################################

database        bdb
suffix          "dc=domain-indonesia,dc=com"
rootdn          "cn=admin,dc=domain-indonesia,dc=com"

# Cleartext passwords, especially for the rootdn, should
# be avoid.  See slappasswd(8) and slapd.conf(5) for details.
# Use of strong authentication encouraged.
rootpw          domainldap
# The database directory MUST exist prior to running slapd AND
# should only be accessible by the slapd and slap tools.
# Mode 700 recommended.
directory       /usr/local/openldap2.4/var/openldap-data
# Indices to maintain

index objectClass,entryCSN,entryUUID    eq,pres
index ou,cn,mail,surname,givenname      eq,pres,sub
index uidNumber,gidNumber,loginShell    eq,pres
index uid,memberUid                     eq,pres,sub
index nisMapName,nisMapEntry            eq,pres,sub


overlay syncprov
syncprov-checkpoint 100 10
syncprov-sessionlog 100

# Global section
serverID    2
# database section

# syncrepl directive
syncrepl        rid=001
                provider=ldap://192.168.11.215
                bindmethod=simple
                binddn="cn=admin,dc=domain-indonesia,dc=com"
                credentials=domainldap
                searchbase="dc=domain-indonesia,dc=com"
                schemachecking=on
                type=refreshAndPersist
                retry="60 +"
mirrormode on

user@morotai ~$
{% endhighlight %}

B.3.2.2 ldap.conf


$ vi /etc/ldap.conf:

{% highlight bash %}
#Begin
host 127.0.0.1
base dc=finnet-indonesia,dc=com
timelimit 120
bind_timelimit 120
idle_timelimit 3600
nss_initgroups_ignoreusers root,ldap,named,avahi,haldaemon,dbus,radvd,tomcat,radiusd,news,mailman,nscd,gdm,username,rudi
uri ldap://192.168.11.216/
ssl no
tls_cacertdir /etc/openldap/cacerts
pam_password md5
{% endhighlight %}
#EOF


#####B.3.2.3 Auth

<script src="https://gist.github.com/1433829.js?file=b323.sh">
</script>

#####B.3.2.4 PAM 

$ vi /etc/pam.d/system-auth

PAM:

{% highlight bash %}
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        sufficient    pam_ldap.so use_first_pass
auth        required      pam_deny.so

account     required      pam_unix.so broken_shadow
account     sufficient    pam_succeed_if.so uid < 500 quiet
account     sufficient    pam_localuser.so
account     default=bad success=ok user_unknown=ignore pam_ldap.so
account     required      pam_permit.so

session required pam_mkhomedir.so skel=/etc/skel/ umask=0022

password    requisite     pam_cracklib.so try_first_pass retry=3
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
password    sufficient    pam_ldap.so use_authtok
password    required      pam_deny.so

session     required      pam_mkhomedir.so skel=/etc/skel/ umask=0066

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     success=1 default=ignore pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
session     optional      pam_ldap.so
{% endhighlight %}






##C. Testing


###C.1 Test Openssl


{% highlight bash %}
root@morotai ssl# openssl s_client -connect localhost:636 -showcerts
CONNECTED(00000003)
depth=0 /C=ID/ST=Jakarta/L=Jakarta/O=Finnet/OU=Finnet/CN=morotai.finnet-indonesia.com/emailAddress=username@noc.finnet-indonesia.com
verify error:num=18:self signed certificate
verify return:1
depth=0 /C=ID/ST=Jakarta/L=Jakarta/O=Finnet/OU=Finnet/CN=morotai.finnet-indonesia.com/emailAddress=username@noc.finnet-indonesia.com
verify return:1
---
Certificate chain
 0 s:/C=ID/ST=Jakarta/L=Jakarta/O=Finnet/OU=Finnet/CN=morotai.finnet-indonesia.com/emailAddress=username@noc.finnet-indonesia.com
   i:/C=ID/ST=Jakarta/L=Jakarta/O=Finnet/OU=Finnet/CN=morotai.finnet-indonesia.com/emailAddress=username@noc.finnet-indonesia.com
-----BEGIN CERTIFICATE-----
MIID4zCCA0ygAwIBAgIJAPqgYszfNWU6MA0GCSqGSIb3DQEBBQUAMIGoMQswCQYD
VQQGEwJJRDEQMA4GA1UECBMHSmFrYXJ0YTEQMA4GA1UEBxMHSmFrYXJ0YTEPMA0G
A1UEChMGRmlubmV0MQ8wDQYDVQQLEwZGaW5uZXQxJTAjBgNVBAMTHG1vcm90YWku
ZmlubmV0LWluZG9uZXNpYS5jb20xLDAqBgkqhkiG9w0BCQEWHWRpYW5Abm9jLmZp
bm5ldC1pbmRvbmVzaWEuY29tMB4XDTEwMDkwODExMDA0MloXDTIwMDkwNTExMDA0
MlowgagxCzAJBgNVBAYTAklEMRAwDgYDVQQIEwdKYWthcnRhMRAwDgYDVQQHEwdK
YWthcnRhMQ8wDQYDVQQKEwZGaW5uZXQxDzANBgNVBAsTBkZpbm5ldDElMCMGA1UE
AxMcbW9yb3RhaS5maW5uZXQtaW5kb25lc2lhLmNvbTEsMCoGCSqGSIb3DQEJARYd
ZGlhbkBub2MuZmlubmV0LWluZG9uZXNpYS5jb20wgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBAK1DMnEL0a7yGcjgvgok1X4sA3auRLYhkVS4/KlyLVTq6hmzQ3St
a+FbpxVZ74nqI7puORT8V/YTNwgxgWyASzmwW1EgnFlDFCFasRrhSbvEoPaWERPY
O2d7kw9PzodJxxxT5auRKjZiLWGoIiQaxlXKWclFvQFQlpmRWUhBk7uDAgMBAAGj
ggERMIIBDTAdBgNVHQ4EFgQUPoQzE33QnV+O/iqUk5ovxmmJjn8wgd0GA1UdIwSB
1TCB0oAUPoQzE33QnV+O/iqUk5ovxmmJjn+hga6kgaswgagxCzAJBgNVBAYTAklE
MRAwDgYDVQQIEwdKYWthcnRhMRAwDgYDVQQHEwdKYWthcnRhMQ8wDQYDVQQKEwZG
aW5uZXQxDzANBgNVBAsTBkZpbm5ldDElMCMGA1UEAxMcbW9yb3RhaS5maW5uZXQt
aW5kb25lc2lhLmNvbTEsMCoGCSqGSIb3DQEJARYdZGlhbkBub2MuZmlubmV0LWlu
ZG9uZXNpYS5jb22CCQD6oGLM3zVlOjAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEB
BQUAA4GBAGKGyIswW15KesUIszaZ9fHxi749HSSO0R+izduKjWYZnERfWvm+M8QT
L00Db1sL17iarX57sQwLQSqtRsZVSALgZ6rhIvtwHlMsfPULI2rofd50U9BquHVp
YRehmyS45vYR+D2i+fpb5cL3zYEg+foV/TG3qwwIJBCKm8ugzvgh
-----END CERTIFICATE-----
---
Server certificate
subject=/C=ID/ST=Jakarta/L=Jakarta/O=Finnet/OU=Finnet/CN=morotai.finnet-indonesia.com/emailAddress=username@noc.finnet-indonesia.com
issuer=/C=ID/ST=Jakarta/L=Jakarta/O=Finnet/OU=Finnet/CN=morotai.finnet-indonesia.com/emailAddress=username@noc.finnet-indonesia.com
---
No client certificate CA names sent
---
SSL handshake has read 1168 bytes and written 319 bytes
---
New, TLSv1/SSLv3, Cipher is AES256-SHA
Server public key is 1024 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
SSL-Session:
    Protocol  : TLSv1
    Cipher    : AES256-SHA
    Session-ID: EA07728E6693DDC8C536811BEEFEBA426E920453868BF0C9409BDA85CDCE2D0B
    Session-ID-ctx:
    Master-Key: 7425A4061CD8951C33BA508DA73E50BDEA31C7144231347F478ACCBA361177C495C028E3F4F7BD55E93108D10CA7DD09
    Key-Arg   : None
    Krb5 Principal: None
    Start Time: 1290683048
    Timeout   : 300 (sec)
    Verify return code: 18 (self signed certificate)
---
{% endhighlight %}




###C.2 Test Openldap

ldif data:

{% highlight bash %}
$ cat /home/username/tes2.ldif
dn: ou=Timur,dc=finnet-indonesia,dc=com
objectClass: organizationalUnit
ou: Timur
description: Divre Bagian Timur
{% endhighlight %}



####C.2.1 Non-ssl

debug:
{% highlight bash %}
sudo /usr/local/openldap2.4/libexec/slapd -h ldap:/// -u ldap -f /usr/local/openldap2.4/etc/openldap/slapd.conf -d -1
{% endhighlight %}

search:
{% highlight bash %}
sudo /usr/local/openldap2.4/bin/ldapsearch -x
{% endhighlight %}


add:
{% highlight bash %}
sudo /usr/local/openldap2.4/bin/ldapadd -x -D "cn=admin,dc=domain-indonesia,dc=com" -f /home/user/tes2.ldif -W
{% endhighlight %}

delete:
{% highlight bash %}
sudo /usr/local/openldap2.4/bin/ldapdelete -D "cn=admin,dc=domain-indonesia,dc=com" -w domainldap "dc=domain-indonesia,dc=com" "ou=Barat,dc=domain-indonesia,dc=com"
{% endhighlight %}



####C.2.2 With-ssl


debug:
{% highlight bash %}
sudo /usr/local/openldap/libexec/slapd -h "ldaps:/// ldap:///" -u ldap -f /usr/local/openldap2.4/etc/openldap/slapd.conf -d -1
{% endhighlight %}

search:
{% highlight bash %}
sudo /usr/local/openldap/bin/ldapsearch -x
{% endhighlight %}


add:
{% highlight bash %}
sudo /usr/local/openldap/bin/ldapadd -x -D "cn=admin,dc=domain-indonesia,dc=com" -f /home/user/tes2.ldif -W
{% endhighlight %}

delete:
{% highlight bash %}
sudo /usr/local/openldap/bin/ldapdelete -D "cn=admin,dc=domain-indonesia,dc=com" -w domainldap "dc=domain-indonesia,dc=com" "ou=Barat,dc=domain-indonesia,dc=com"
{% endhighlight %}


###Open LDAP Script


Grab this openldap.sh script and put into `/etc/init.d/`.

<script src="https://gist.github.com/1116366.js?file=openldap.sh" type="text/javascript">
</script>


###C.3 Start, stop and restart Service ldap

start:
{% highlight bash %}
# /etc/init.d/ldap start
{% endhighlight %}

stop:
{% highlight bash %}
# /etc/init.d/ldap stop
{% endhighlight %}

restart:
{% highlight bash %}
# /etc/init.d/ldap restart
{% endhighlight %}



##referensi:



1.[http://s0t4.blogspot.com/2010/05/instalasi-source-openldap-2421-di.html](http://s0t4.blogspot.com/2010/05/instalasi-source-openldap-2421-di.html)
2.[http://download.oracle.com/docs/cd/E17076_01/html/installation/build_unix.html](http://download.oracle.com/docs/cd/E17076_01/html/installation/build_unix.html)
3.[http://lists.arthurdejong.org/openldap-technical/2008/09/msg00011.html](http://lists.arthurdejong.org/openldap-technical/2008/09/msg00011.html)
4.[http://www.openldap.org/doc/admin24/replication.html](http://www.openldap.org/doc/admin24/replication.html)
5.[http://itsecureadmin.com/wiki/index.php/OpenLDAP_Multi-Master_Replication](http://itsecureadmin.com/wiki/index.php/OpenLDAP_Multi-Master_Replication)
6.[http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch31_:_Centralized_Logins_Using_LDAP_and_RADIUS](http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch31_:_Centralized_Logins_Using_LDAP_and_RADIUS)
