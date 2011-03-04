--- 
layout: post_new
title: Clustering Openldap 2.4 dengan Mirror Node Replication di CentOs 5.5
categories: [clustering, openldap, mirroring, replicate, centos]
date: 2010-09-05 10:52:53
---

##Installasi

##Barkeley DB 4.8

{% highlight bash %}

 cd /usr/local/src/
 wget -c http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz
 tar -xzvf db-4.8.30.tar.gz
 cd db-4.8.30
 cd build_unix
 ../dist/configure --prefix=/usr/local/BerkeleyDB4.8.30
 make clean
 make
 make install
{% endhighlight %}

###update ldconfig

{% highlight bash %}
 CPPFLAGS="-I/usr/local/BerkeleyDB4.8.30/include"
 export CPPFLAGS
 LDFLAGS="-L/usr/local/lib -L/usr/local/BerkeleyDB4.8.30/lib -R/usr/local/BerkeleyDB4.8.30/lib"
 export LDFLAGS
 LD_LIBRARY_PATH="/usr/local/BerkeleyDB4.8.30/lib"
 export LD_LIBRARY_PATH
{% endhighlight %}


##openldap 2.4

{% highlight bash %}
 cd /usr/local/src/
 wget -c ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.23.tgz
 ./configure --prefix=/usr/local/openldap2.4
 make depend
 make
 make install
{% endhighlight %}



##Konfigurasi:

file conf:

{% highlight bash %}
/usr/local/openldap2.4/etc/openldap/slapd.conf
/usr/local/openldap2.4/etc/openldap/ldap.conf
{% endhighlight %}



##SETUP MIRROR NODE

**SERVER1/192.168.11.215:**

{% highlight xml %}
[user@server1 ~]$ sudo cat /usr/local/openldap2.4/etc/openldap/slapd.conf
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
[user@server1 ~]$
{% endhighlight %}


**SERVER2/192.168.11.216:**


{% highlight xml %}
[user@server2 ~]$ sudo cat /usr/local/openldap2.4/etc/openldap/slapd.conf
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

[user@server2 ~]$
{% endhighlight %}

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

Cara mengujinya dengan mengaktifkan ke dua server dalam keadaan debug mode agar terlihat log errornya, lalu tambahkan data di server1 misalnya, terus cek di server 2 apakah automatis terupdate. Jika sudah terupdate lakukan hal yang sama dengan server 2. Seharusnya ke dua server akan tetap sinkronise jika ditambahkan dari kedua nya.

semoga membantu :)

referensi:

1. [http://download.oracle.com/docs/cd/E17076_01/html/installation/build_unix.html](http://download.oracle.com/docs/cd/E17076_01/html/installation/build_unix.html)
2. [http://s0t4.blogspot.com/2010/05/instalasi-source-openldap-2421-di.html](http://s0t4.blogspot.com/2010/05/instalasi-source-openldap-2421-di.html)
3. [http://lists.arthurdejong.org/openldap-technical/2008/09/msg00011.html](http://lists.arthurdejong.org/openldap-technical/2008/09/msg00011.html)
4. [http://www.openldap.org/doc/admin24/replication.html](http://www.openldap.org/doc/admin24/replication.html)
5. [http://itsecureadmin.com/wiki/index.php/OpenLDAP_Multi-Master_Replication](http://itsecureadmin.com/wiki/index.php/OpenLDAP_Multi-Master_Replication)

bacaan menarik: [http://www.centos.org/docs/5/html/CDS/ag/8.0/Managing_Replication-Replication_Scenarios.html](http://www.centos.org/docs/5/html/CDS/ag/8.0/Managing_Replication-Replication_Scenarios.html)
