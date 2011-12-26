--- 
layout: post_new
title: How to create RHEL 5.4 Repository for installation package
date: 2011-04-23 14:00:08
categories: [RHEL, repo]
updated: 2011-04-23 14:36:03
---

How to create RHEL 5.4 Repository for installation package

things need:

1. ISO RHEL 5.4 ( rhel-5.4_x86_64.iso )
2. a RHEL server for sharing repository

to do all step, needed root user. become root to create directory `/mnt/iso`. then mount `ISO` file on directory that created (`/mnt/iso`).


	root@utcepos4 ~# mkdir /mnt/iso
	root@utcepos4 ~# mount /root/rhel-5.4_x86_64.iso /mnt/iso -o loop


We check use `df -h` command:


	root@utcepos4 ~# df -h
	Filesystem            Size  Used Avail Use% Mounted on
	/dev/sda2              20G   15G  3.3G  82% /
	/dev/sda5              48G  201M   45G   1% /home
	/dev/sda1              99M   13M   82M  13% /boot
	tmpfs                  12G     0   12G   0% /dev/shm
	/dev/sda6              48G   15G   31G  32% /apps
	/root/rhel-5.4_x86_64.iso
        	              3.4G  3.4G     0 100% /mnt/iso


K, `ISO` file already mounted on `/mnt/iso`. 
Next step check `createrepo` package. what is already installed ? to do, can use command `rpm -qa | grep package_name`


	root@utcepos4 ~# rpm -qa | grep createrepo
	createrepo-0.4.11-3.el5
	root@utcepos4 ~# 


Good, `createrepo package` is already installed. What if it's not already installed ? we can install using command `rpm -ivh package_name`.


	root@utcepos4 ~# rpm -ivh /mnt/iso/Server/createrepo-0.4.11-3.el5.noarch.rpm


K, how we know path of the package ?. we can do it using command `find /letak/mount/iso | grep package_name`.


	root@utcepos4 ~# find /mnt/iso | grep createrepo
	/mnt/iso/Server/createrepo-0.4.11-3.el5.noarch.rpm
	root@utcepos4 ~# 


Next step are create repository:



	root@utcepos4 ~# mkdir -p /mnt/repo/iso;
	root@utcepos4 ~# mount --bind /mnt/iso /mnt/repo/iso


The command above is to make the repo directory in `/mnt` and create an iso directory in the directory `/mnt/repo`. <br/>
Then mount `/mnt/iso` into the directory `/mnt/repo/iso`.<br/>
The next step into the directory `/mnt/repo` to create a repository with the command `createrepo`



	root@utcepos4 ~# cd /mnt/repo
	root@utcepos4 repo# createrepo .
	3181/3181 - rpms/xen-devel-3.0.3-94.el5.x86_64.rpm                              _64.rpm_64.rpm
	Saving Primary metadata
	Saving file lists metadata
	Saving other metadata
	root@utcepos4 repo# 


Metadata for the repository has been created, the next step `yum` configuration setting on the client. Here are some ways the media used:

1. Dengan methode file local.
2. Dengan `http` / dengan `NFS`.

1. Dengan methode file local.

Dengan methode file local ada beberapa kelebihan dan kekurangan, 
yaitu cepat diakses karena melalui media local dan tidak bisa diakses dari client lain karena membutuhkan interaksi client-server. 
Maka dari itu bisa digunakan HTTP atau NFS.

Untuk menyetting konfigurasi dengan methode file local bisa dengan langkah berikut:

buat file rhel.repo lalu isi sesuai dibawah ini dan simpan di direktori `/etc/yum.repos.d/`


	root@utcepos4 ~# vim /etc/yum.repos.d/rhel.repo 
	rhel
	name=Red Hat 
	baseurl=file:///mnt/repo/
	enabled=1
	gpgcheck=0


jika sudah kita check dengan perintah yum update



	root@utcepos4 ~# yum update
	Loaded plugins: rhnplugin, security
	This system is not registered with RHN.
	RHN support will be disabled.
	rhel                                                                                                                                 |  951 B     00:00     
	rhel/primary                                                                                                                         | 796 kB     00:00     
	rhel                                                                                                                                              3181/3181
	Skipping security plugin, no data
	Setting up Update Process
	No Packages marked for Update
	root@utcepos4 ~#
	


kita cek paket yang available (belum terinstall)



	root@utcepos4 ~# yum list available | tail
	This system is not registered with RHN.
	RHN support will be disabled.
	yum-list-data.noarch                        1.1.16-13.el5              rhel     
	yum-protect-packages.noarch                 1.1.16-13.el5              rhel     
	yum-protectbase.noarch                      1.1.16-13.el5              rhel     
	yum-tmprepo.noarch                          1.1.16-13.el5              rhel     
	yum-updateonboot.noarch                     1.1.16-13.el5              rhel     
	yum-utils.noarch                            1.1.16-13.el5              rhel     
	yum-verify.noarch                           1.1.16-13.el5              rhel     
	yum-versionlock.noarch                      1.1.16-13.el5              rhel     
	zsh.x86_64                                  4.2.6-3.el5                rhel     
	zsh-html.x86_64                             4.2.6-3.el5                rhel     
	root@utcepos4 ~# 
	

kita coba install paket `zsh.x86_64`



	root@utcepos4 ~# yum install zsh.x86_64
	Loaded plugins: rhnplugin, security
	This system is not registered with RHN.
	RHN support will be disabled.
	Setting up Install Process
	Resolving Dependencies
	--> Running transaction check
	---> Package zsh.x86_64 0:4.2.6-3.el5 set to be updated
	--> Finished Dependency Resolution

	Dependencies Resolved

	============================================================================================================================================================
	 Package                           Arch                                 Version                                    Repository                          Size
	============================================================================================================================================================
	Installing:
	 zsh                               x86_64                               4.2.6-3.el5                                rhel                               1.7 M

	Transaction Summary
	============================================================================================================================================================
	Install      1 Package(s)         
	Update       0 Package(s)         
	Remove       0 Package(s)         
	
	Total download size: 1.7 M
	Is this ok y/N: y
	Downloading Packages:
	Running rpm_check_debug
	Running Transaction Test
	Finished Transaction Test
	Transaction Test Succeeded
	Running Transaction
	  Installing     : zsh                                                                                                                                  1/1 

	Installed:
	  zsh.x86_64 0:4.2.6-3.el5                                                                                                                                  

	Complete!
	root@utcepos4 ~# 



sampai langkah disini kita sudah berhasil membuat repositori, 
tapi hanya untuk akses dari server itu sendiri. Untuk client harus diperlukan interaksi client-server (HTTP/NFS/FTP). disini kita coba pakai HTTP dan NFS.

Langkah yang harus dipersiapkan:

masuk ke direktori /mnt/iso lalu membuat direktori reporhel di /mnt/ untuk repositori baru.

	root@utcepos4 ~# cd /mnt/iso
	root@utcepos4 iso# mkdir /mnt/reporhel;


membuat direktori Server,VT,Cluster,dan ClusterStorage untuk repositori agar kita bisa melihat grouplist pada perintah yum grouplist
 

	root@utcepos4 iso# mkdir /mnt/reporhel/{Server,VT,Cluster,ClusterStorage}


setelah itu kita akan mencari semua file rpm dalam direktori iso dan membuat symbolic link setiap file yang ditemukan ke dalam direktori /mnt/reporhel.

	root@utcepos4 iso# find . -name "*.rpm" -exec ln -s `pwd`/{} /mnt/reporhel/{} \;


Langkah selanjutnya mengkopi file `comps*.xml` ke direktori yang sesuai dengan Kategorinya (Server,VT,Cluster,ClusterStorage).


	root@utcepos4 iso# cp Server/repodata/comps-rhel5-server-core.xml /mnt/reporhel/Server/;
	root@utcepos4 iso# cp VT/repodata/comps-rhel5-vt.xml /mnt/reporhel/VT/;
	root@utcepos4 iso# cp Cluster/repodata/comps-rhel5-cluster.xml /mnt/reporhel/Cluster/;
	root@utcepos4 iso# cp ClusterStorage/repodata/comps-rhel5-cluster-st.xml /mnt/reporhel/ClusterStorage/;



Selanjutnya pindah ke direktori /mnt/reporhel. lalu memulai membuat repositorynya

	root@utcepos4 iso# cd /mnt/reporhel/


	root@utcepos4 reporhel# createrepo -g comps-rhel5-vt.xml /mnt/reporhel/VT/
	72/72 - etherboot-roms-5.4.4-10.el5.x86_64.rpm                                  
	Saving Primary metadata
	Saving file lists metadata
	Saving other metadata
	root@utcepos4 reporhel# createrepo -g comps-rhel5-server-core.xml /mnt/reporhel/Server/
	3040/3040 - pirut-1.3.28-13.el5.noarch.rpm                                  
	Saving Primary metadata
	Saving file lists metadata
	Saving other metadata
	root@utcepos4 reporhel# createrepo -g comps-rhel5-cluster.xml /mnt/reporhel/Cluster/;
	32/32 - Cluster_Administration-si-LK-5.2-1.noarch.rpm                           
	Saving Primary metadata
	Saving file lists metadata
	Saving other metadata
	root@utcepos4 reporhel# createrepo -g comps-rhel5-cluster-st.xml /mnt/reporhel/ClusterStorage/;
	36/36 - Global_File_System-it-IT-5.2-1.noarch.rpm                               
	Saving Primary metadata
	Saving file lists metadata
	Saving other metadata
	root@utcepos4 reporhel# 



sampai disini langkah di server sudah selesai. langkah selanjutna adalah menyetting media(pilih salah satu) yang akan digunakan di client yum nya.


2. Dengan dengan NFS/HTTP .

2.a. Menyetting media repository dengan NFS:


Pastikan paket NFS sudah terinstall, jika belum bisa diinstall dengan metode file local lalu ketik yum install nfs. 
Selanjutnya mengedit konfigurasi NFS. Setting NFS di server repositori:



	root@utcepos4 ~# vim /etc/exports 

	/mnt/reporhel/ *(ro)



reload konfigurasi NFS lalu cek apa sudah available:

	root@utcepos4 ~# service nfs reload
	root@utcepos4 ~# exportfs 
	/mnt/reporhel   <world>
	/mnt/iso     	<world>


cek di Client apakah sudah bisa diakses NFS nya:



	root@utcadv6 ~# showmount -e 192.168.1.111
	Export list for 192.168.1.111:
	/mnt/iso      *
	/mnt/reporhel *
	root@utcadv6 ~#





Jika sudah, lakukan langkah di client. Buat direktori reporhel dan iso di direktori /mnt. 
lalu memount NFS /mnt/reporhel dan /mnt/iso di server (dalam contoh 192.168.1.111) ke client (utcadv6).



	root@utcadv6 ~# mkdir /mnt/{reporhel,iso}
	root@utcadv6 ~# mount 192.168.1.111:/mnt/reporhel /mnt/reporhel
	root@utcadv6 ~# mount 192.168.1.111:/mnt/iso /mnt/iso



Jika sudah cek dengan perintah mount


	root@utcadv6 ~# mount
	/dev/sda3 on / type ext3 (rw)
	proc on /proc type proc (rw)
	sysfs on /sys type sysfs (rw)
	devpts on /dev/pts type devpts (rw,gid=5,mode=620)
	/dev/sda6 on /apps type ext3 (rw)
	/dev/sda2 on /home type ext3 (rw)
	/dev/sda1 on /boot type ext3 (rw)
	tmpfs on /dev/shm type tmpfs (rw)
	none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
	sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
	192.168.1.111:/mnt/reporhel on /mnt/local type nfs (rw,addr=192.168.1.111)
	192.168.1.111:/mnt/iso on /mnt/iso type nfs (rw,addr=192.168.1.111)


oke, nfs sudah kita mount. langkah selanjut membuat file rhel-5.4.repo lalu disimpan ke direktori /etc/yum.repos.d/



	root@utcadv6 ~# cat /etc/yum.repos.d/rhel-5.4.repo 
	Server
	name=Server
	baseurl=file:///mnt/local/Server/
	enabled=1
	gpgcheck=0
	VT
	name=Virtualization
	baseurl=file:///mnt/local/VT/
	enabled=	1
	gpgcheck=0
	Cluster
	name=Cluster
	baseurl=file:///mnt/local/Cluster/
	enabled=1
	gpgcheck=0
	ClusterStorage
	name=Cluster Storage
	baseurl=file:///mnt/local/ClusterStorage/
	enabled=1
	gpgcheck=0
	root@utcadv6 ~# 





Jika sudah lalu update dengan perintah yum update. 
*lakukan yum clean all jika diperlukan / jika ingin menghapus cache repositori. hal ini dilakukan biasanya setelah mengupdate konfigurasi yum repository d client*


	root@utcepos4 yum.repos.d# yum clean all
	Loaded plugins: rhnplugin, security
	Cleaning up Everything
	root@utcepos4 yum.repos.d# yum update
	Loaded plugins: rhnplugin, security
	This system is not registered with RHN.
	RHN support will be disabled.
	Cluster                                                                                                                              | 1.1 kB     00:00     
	Cluster/primary                                                                                                                      | 5.8 kB     00:00     
	Cluster                                                                                                                                               32/32
	ClusterStorage                                                                                                                       | 1.1 kB     00:00     
	ClusterStorage/primary                                                                                                               | 7.5 kB     00:00     
	ClusterStorage                                                                                                                                        36/36
	Server                                                                                                                               | 1.1 kB     00:00     
	Server/primary                                                                                                                       | 1.0 MB     00:00     
	Server                                                                                                                                            3040/3040
	VT                                                                                                                                   | 1.1 kB     00:00     
	VT/primary                                                                                                                           |  20 kB     00:00     
	VT                                                                                                                                                    72/72
	Skipping security plugin, no data
	Setting up Update Process
	No Packages marked for Update
	root@utcepos4 yum.repos.d#



untuk melihat repositori yang aktif bisa dengan perintah yum repolist -v


	root@utcepos4 yum.repos.d# yum repolist -v
	Loading "rhnplugin" plugin
	Loading "security" plugin
	Config time: 0.039
	This system is not registered with RHN.
	RHN support will be disabled.
	Yum Version: 3.2.22
	Repo-id     : Cluster
	Repo-name   : Cluster
	Repo-status : enabled:
	Repo-updated: Thu Mar 17 21:07:58 2011
	Repo-pkgs   : 32
	Repo-size   : 68 M
	Repo-baseurl: file:///mnt/reporhel/Cluster/

	Repo-id     : ClusterStorage
	Repo-name   : Cluster Storage
	Repo-status : enabled:
	Repo-updated: Thu Mar 17 21:08:11 2011
	Repo-pkgs   : 36
	Repo-size   : 9.8 M
	Repo-baseurl: file:///mnt/reporhel/ClusterStorage/

	Repo-id     : Server
	Repo-name   : Server
	Repo-status : enabled:
	Repo-updated: Thu Mar 17 21:07:02 2011
	Repo-pkgs   : 3,040
	Repo-size   : 3.0 G
	Repo-baseurl: file:///mnt/reporhel/Server/

	Repo-id     : VT
	Repo-name   : Virtualization
	Repo-status : enabled:
	Repo-updated: Thu Mar 17 21:07:43 2011
	Repo-pkgs   : 72
	Repo-size   : 71 M
	Repo-baseurl: file:///mnt/reporhel/VT/

	repolist: 3,180
	root@utcepos4 yum.repos.d# 



sampai disini untuk tahap repository dengan NFS sudah selesai. Langkah berikut nya repository dengan HTTP.



2.b. HTTP

Yang diperlukan adalah service HTTP di Server repository.


Pastikan paket httpd sudah terinstall, jika belum bisa diinstall dengan metode file local lalu ketik yum install httpd. Selanjutnya mengedit konfigurasi httpd.conf

	root@utcepos4 ~# vim /etc/httpd/conf/httpd.conf 


cari bagian `www/html` dengan perintah `/www\/html` pada editor vim

jika sudah ketemu, maka akan terlihat seperti berikut


	DocumentRoot "/var/www/html"


Ganti dengan

	DocumentRoot "/mnt/reporhel/"


lalu cari lagi maka akan ketemu seperti berikut:


	<Directory "/var/www/html">


ganti dengan


	<Directory "/mnt/reporhel">



jika sudah simpan konfigurasi `httpd.conf` . lalu aktifkan.


	root@utcepos4 ~# chkconfig httpd on
	root@utcepos4 ~# service httpd start
	Starting httpd: httpd: Could not reliably determine the server's fully qualified domain name, using 10.80.120.77 for ServerName
                                                             OK  
	root@utcepos4 ~# 


Lalu set konfigurasi yum (/etc/yum.repos.d/rhel-5.4.repo) di client nya:


	Server
	name=Server
	baseurl=http://192.168.1.111/Server/
	enabled=1
	gpgcheck=0
	VT
	name=Virtualization
	baseurl=http://192.168.1.111/VT/
	enabled=1
	gpgcheck=0
	Cluster
	name=Cluster
	baseurl=http://192.168.1.111/Cluster/
	enabled=1
	gpgcheck=0
	ClusterStorage
	name=Cluster Storage
	baseurl=http://192.168.1.111/ClusterStorage/
	enabled=1
	gpgcheck=0
	


dimana 192.168.1.111 adalah server yang menshare repository nya. 
lalu di client, lakukan yum clean all, terus `yum repolist -v` untuk menghapus cache repository client dan mengupdate cache repo serta melihat list repo.


	root@utcadv2 ~# yum clean all
	Loaded plugins: rhnplugin, security
	Cleaning up Everything
	root@utcadv2 ~# yum repolist -v
	Loading "rhnplugin" plugin
	Loading "security" plugin
	Config time: 0.032
	This system is not registered with RHN.
	RHN support will be disabled.
	Yum Version: 3.2.22
	Cluster                                                                                                                              | 1.1 kB     00:00     
	Cluster/primary                                                                                                                      | 5.8 kB     00:00     
	Cluster                                                                                                                                               32/32
	ClusterStorage                                                                                                                       | 1.1 kB     00:00     
	ClusterStorage/primary                                                                                                               | 7.5 kB     00:00     
	ClusterStorage                                                                                                                                        36/36
	Server                                                                                                                               | 1.1 kB     00:00     
	Server/primary                                                                                                                       | 1.0 MB     00:00     
	Server                                                                                                                                            3040/3040
	VT                                                                                                                                   | 1.1 kB     00:00     
	VT/primary                                                                                                                           |  20 kB     00:00     
	VT                                                                                                                                                    72/72
	Repo-id     : Cluster
	Repo-name   : Cluster
	Repo-status : enabled:
	Repo-updated: Fri Mar 18 17:43:53 2011
	Repo-pkgs   : 32
	Repo-size   : 68 M
	Repo-baseurl: http://192.168.1.111/Cluster/

	Repo-id     : ClusterStorage
	Repo-name   : Cluster Storage
	Repo-status : enabled:
	Repo-updated: Fri Mar 18 17:44:00 2011
	Repo-pkgs   : 36
	Repo-size   : 9.8 M
	Repo-baseurl: http://192.168.1.111/ClusterStorage/

	Repo-id     : Server
	Repo-name   : Server
	Repo-status : enabled:
	Repo-updated: Fri Mar 18 17:43:25 2011
	Repo-pkgs   : 3,040
	Repo-size   : 3.0 G
	Repo-baseurl: http://192.168.1.111/Server/
	
	Repo-id     : VT
	Repo-name   : Virtualization
	Repo-status : enabled:
	Repo-updated: Fri Mar 18 17:41:34 2011
	Repo-pkgs   : 72
	Repo-size   : 71 M
	Repo-baseurl: http://192.168.1.111/VT/
	
	repolist: 3,180
	root@utcadv2 ~# 




Selesai.

Untuk menginstall semua paket bisa dengan yum groupinstall nama_group_paket. untuk mengetahui nama_group_paket bisa dengan perintah yum grouplist .


	root@utcadv2 ~# yum grouplist
	Loaded plugins: rhnplugin, security
	This system is not registered with RHN.
	RHN support will be disabled.
	Setting up Group Process
	Cluster/group                                                                                                                                                                                                         | 101 kB     00:00     
	ClusterStorage/group                                                                                                                                                                                                  | 105 kB     00:00     
	Server/group                                                                                                                                                                                                          | 1.0 MB     00:00     
	VT/group                                                                                                                                                                                                              | 106 kB     00:00     
	Installed Groups:
	   Administration Tools
	   Editors
	   GNOME Desktop Environment
	   Games and Entertainment
	   Graphical Internet
	   Graphics
	   KDE (K Desktop Environment)
	   Legacy Network Server
	   Legacy Software Development
	   Legacy Software Support
	   Mail Server
	   Network Servers
	   Office/Productivity
	   Printing Support
	   Server Configuration Tools
	   Sound and Video
	   System Tools
	   Text-based Internet
	   X Window System
	Available Groups:
	   Authoring and Publishing
	   Cluster Storage
	   Clustering
	   DNS Name Server
	   Development Libraries
	   Development Tools
	   Engineering and Scientific
	   FTP Server
	   GNOME Software Development
	   Java Development
	   KDE Software Development
	   KVM
	   MySQL Database
	   News Server
	   OpenFabrics Enterprise Distribution
	   PostgreSQL Database
	   Virtualization
	   Web Server
	   Windows File Server
	   X Software Development
	Done




Untuk menginstall semua paket yang belum ke-install (Available Groups):


	root@utcadv2 ~# yum groupinstall "Authoring and Publishing" "Cluster Storage" "Clustering" "DNS Name Server" \
	"Development Libraries" "Development Tools" "Engineering and Scientific" "FTP Server" "GNOME Software Development" \
	"GNOME Software Development" "KDE Software Development" "Java Development" "KVM" "MySQL Database" "News Server" \
	"OpenFabrics Enterprise Distribution" "PostgreSQL Database" "Virtualization" "Web Server" "Windows File Server" "X Software Development"

[http://linuxtechsupport.blogspot.com/2008/06/configuring-yum-in-rhel5.html](http://linuxtechsupport.blogspot.com/2008/06/configuring-yum-in-rhel5.html)

