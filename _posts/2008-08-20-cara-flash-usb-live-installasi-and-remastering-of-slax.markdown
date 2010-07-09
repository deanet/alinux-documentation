--- 
layout: post
title: USB LIVE, INSTALLASI, AND REMASTERING OF SLAX
date: 2008-08-07 07:00:00
---

Slax, merupakan distro turunan Slackware yang sudah merilis hingga saat ini mencapai versi 6.0.7 . Slackware adalah salah satu distro paling tertua dari distro terkenal lainya seperti Red Hat, Debian, Gentoo. Kata orang bilang distro Slackware distro yang paling sulit dan ditakuti karena mode text bangets. Distro Slackware distro yang paling sering digunakan oleh para veteran linux. Mungkin karena mode text bangets yang mereka sukai, dan juga lebih ringan dan stabil ketika mereka memakainya.

Slax distro yang kecil, hanya sekitar 190 MB sizenya. Dengan sedikit tambahan aplikasi kita sedah dapat memutar mp3 sambil internetan, sambil mengerjakan tugas dengan Open Office juga bisa. :P .

Oke, Untuk bahannya yang disiapin antara lain:

##1. USB LIVE

a. File ISO Slax yang bisa di download di [sini](http://www.slax.org/get_slax.php?download=iso) untuk ISO atau di [sini](http://www.slax.org/get_slax.php?download=tar) untuk TAR.
b. USB Flash 250 MB atau yang lebih besar.
c. Disk Format Tool (untuk memformat USB Flash). Contoh Tool bisa didownload di [sini] (http://files.filefront.com/HPUSBFWEXE/;8576665;/fileinfo.html) untuk win, untuk `*nix` bisa pake perintah fdisk.

##2. INSTALLASI

a. File ISO Slax yang bisa di download di [sini](http://www.slax.org/get_slax.php).
b. Slax GUI Installer yang bisa di download di [sini](http://backtrack.serveftp.com/backtrack/misctools/slax6-install.kmdr)
c. Satu partisi dengan size kurang lebih 3500 MB atau lebih.
d. Sebuah partisi swap (sesuaikan dengan 2 atau 3 kali ukuran RAM Disk ).

## 3. REMASTERING

a. Linux Live Script bisa didownload di [sini](http://www.linux-live.org).
b. Kernel Header (optional) bisa didownload di [sini](ftp://ftp.slax.org/Linux-Live/kernels/2.6.24.3/linux-2.6.24.3-i486-1.tgz)
c. Paket-paket tambahan aplikasi (modul lzm) bisa didownload di [sini](http://www.slax.org/modules.php) untuk slax.org atau di [sini](http://backtrack.serveftp.com/wiki/doku.php) untuk backtrack.serveftp.com, atau di [sini](http://www.nimblex.net/index.php?option=com_wrapper&amp;Itemid=60) untuk nimblex.net.

Setelah bahan sudah dipersiapkan, selanjutnya 



# 1. USB LIVE SLAX


Untuk dapat booting dari USB LIVE menggunakan Slax langkahnya adalah:
***a. Menyetting BIOS agar dapat booting dari USB DISK.***

Ini adalah syarat utama / mutlak. Jika BIOS anda tidak support untuk bisa boot dari USB Disk, maka anda bisa menggunakan Floppy sebagai loncatan agar bisa boot dari USB Disk. Tapi saya tidak membahasnya. Gugling coba.

***b. Memformat USB Flash / DISK dengan Disk Format Tool.***

Format file system yang pernah saya gunakan FAT32. Tapi memungkinkan juga kita menggunakan file system EXT2 untuk di linux.

***c. Extrak file TAR slax-6.0.7.tar ke dalam folder USB-LIVE***

	bash-3.1# tar -xf slax-6.0.7.tar -C USB-LIVE

***d. Kopi folder boot dan slax ke USB Disk.***


	bash-3.1# cp -R boot/ /mnt/sdb1/
	bash-3.1# cp -R slax/ /mnt/sdb1/
	bash-3.1# ls -al /mnt/sdb1/
	total 16
	drwxrwxrwx  4 root root 8192 Aug 20 23:10 .
	drwxr-xr-x 16 root root  384 Aug 19 09:38 ..
	drwxrwxrwx  5 root root 4096 Aug 20 23:10 boot
	drwxrwxrwx  7 root root 4096 Aug 20 23:11 slax
	bash-3.1#



***e. Execute file bootinst.sh***

Eksekusi file bootinst.sh yang ada di folder boot/ agar USB Disk bisa booting.


	bash-3.1# /mnt/sdb1/boot/bootinst.sh


reboot dan coba rasakan hasilnya.

NB: Cara ini juga bisa dilakukan untuk bikin backtrack boot via usb. Hanya mengekstrak file ISO nya. lalu mengeksekusi booinst.sh (untuk linux) dan bootinst.bat (untuk windows).


# 2. INSTALLASI SLAX



Untuk Installasi slax ada 2 metode:

***a. Real***

Untuk Opsi Real, Slax akan dijalankan real atau nyata seperti ketika kita menginstall distro lainnya. Caranya sangat mudah. Eksekusi Slax GUI Installer.

pilih source live USB dan target partisi ( 3500 MB) yang akan diinstall.

atau bisa juga menggunakan command Line HardDisk Installer For Slax. Download di [sini](http://backtrack.serveftp.com/backtrack/misctools/bt-cl_installer.sh)


	bash-3.1# bt-cl_installer.sh /boot /mnt/sda5 /dev/sda



***b. Live***

Untuk metode live, caranya sama dengan metode USB-LIVE. hanya saja perlu diperhatikan opsi root devicenya saat pemanggilan di Bootloader.

Contoh dengan Grub:

	title	Slax 6.0.7 LIVE
	root	(hd0,6)
	kernel	/boot/vmlinuz ramdisk_size=6666 root=/dev/ram0 vga=791 rw autoexec=xconf;telinit~4 changes=/slax/
	initrd	/boot/initrd.gz

tambahkan opsi `changes=/slax/` agar setiap perubahan pada sistem live bisa disimpan, dan `telinit~4` untuk GUI atau `3` untuk terminal mode.


#3. REMASTERING SLAX

Saya tidak tahu pasti cara mana yang lebih fleksibel atau mudah dalam remastering slax. Karena setelah gugling sana gugling sini akhirnya menemukan cara yang paling mudah dalam remastering. Pokok utama yang mesti diperhatikan adalah:

***-. initrd.gz***<br/>
***-. vmlinuz***<br/>
***-. nama distro yang bersangkutan.***<br/>
***-. Paket aplikasi lzm.***<br/>


Oke dari pada ngomong ngalor-ngidul gak karuan, kita coba remastering sederhana dulu.

## REMASTERING SEDERHANA

***a. Bekerja di direktori root.***

agar saat proses remastering, file2 yang kita pakai tidak disertakan dalam hasil remastering. maka kita bekerja di direktori /tmp/remastering (misalnya).

***b. Ekstrak linux-2.6.24.3-i486-1.tgz***


	bash-3.1# cd /tmp/
	bash-3.1# mkdir remastering
	bash-3.1# cd remastering/
	bash-3.1# tar -xzf linux-live-6.2.4.tar.gz

***c. Eksekusi file build yang sudah diekstrak.***


	bash-3.1# cd linux-live-6.2.4
	bash-3.1# ./build
	Changing current directory to /tmp/remastering/linux-live-6.2.4
	Name of your live distro [hit enter for mylinux]: deanet


beri nama distro nya (deanet misalnya)

	Linux Live scripts were installed successfuly in /
	Enter path for the kernel you'd like to use [hit enter for /boot/vmlinuz]:

tekan enter untuk menggunakan kernel yang sedang berjalan (slax 6.0.7: 2.6.24.5 ).


***d. Tunggu sampai proses kompresi selesai. Dan hasil remaster bisa dilihat di dalam folder /tmp/live_data_xxxx . Dimana xxxx adalah angka random.***


Langkah selanjutnya adalah Testing. Untuk testing, anda bisa menggunakan LIVE USB, atau membuat File ISO dan memboot nya dari CD ataupun emulator sperti qemu.
Oke, untuk testing via LIVE USB caranya sama dengan Nomor 1 (USB LIVE). Kopi kedua folder yang berada di folder `/tmp/live_data_xxxx`

Untuk bikin file ISO, tinggal execute file `make_iso` yang berada dalam folder `/tmp/live_data_xxxx/deanet/`


	bash-3.1# ls
	boot	deanet
	bash-3.1# ./deanet/make_iso.sh
	Target ISO file name [ Hit enter for /tmp/deanet.iso ]:


okeh, kalo file ISO udah jadi, kalo mau pake emulator (qemu) bisa dengan perintah

	
	bash-3.1# qemu -cdrom deanet.iso -no-kqemu

Jika belum ada qemu, bisa install paketnya


	bash-3.1# lzm2dir qemu-0.9.1-i686-1.lzm /


**Tips:**
## REMASTERING dengan CUZTOMIZE KERNEL

Untuk cara ini caranya sama dengan yang remastering sederhana, hanya saja ketika tidak ingin menggunakan kernel yang sedang berjalan (slax 6.0.7: 2.6.24.5 ) dapat menggunakan kernel header yang sudah disiapkan sama [linux-live.org](http://linux-live.org)

***a. buat folder kernel-header di `/tmp/remastering` dan ekstrak `linux-2.6.24.3-i486-1.tgz` ke folder kernel-header***


	bash-3.1# pwd
	/tmp/remastering
	bash-3.1# mkdir kernel-header
	bash-3.1# tar -xzf linux-2.6.24.3-i486-1.tgz -C kernel-header/
	bash-3.1# ls kernel-header/
	boot	etc	lib	usr
	bash-3.1#

***b. ikuti langkah a,b,c pada `REMASTER SEDERHANA`, hanya saja ketika memilih kernel, pilih kernel header dari kernel header yang sudah diekstrak***



	Enter path for the kernel you'd like to use [hit enter for /boot/vmlinuz]: /tmp/remastering/kernel-header/boot/vmlinuz
	Creating LiveCD from your Linux
	some debug information can be found in /tmp/linux-live-debug.log
	copying cd-root to /tmp/live_data_23068, using kernel from /tmp/remastering/kernel-header/boot/vmlinuz


Untuk menambahkan paket tanpa proses remaster bisa ditambahkan ke dalam direktori `modules`.

File under direktori tools adalah tools2 yang digunakan untuk:
a. Mengaktifkan dan menonaktifkan modul.
b. Mengubah paket debian menjadi lzm
c. Mengubah paket lzm menjadi direktori
d. Mengubah paket tgz menjadi lzm.
e. Kurang lebihnya sperti itu, yang lain cari tahu sendiri :P

beberapa file menarik:

`make_iso.sh / bat`, `bootinst.sh / bat`, `syslinux.cfg`, `isolinux.cfg`

Untuk menambahkan paket pada saat live (on the fly) bisa dengan:

	lzm2dir nama_paket /

Dan masih banyak tips yang lainnya. :)


**referensi**:
- [slax.org](http://www.slax.org)
- [remote-exploit.org](http://www.remote-exploit.org)
- [backtrack.serveftp.com](http://backtrack.serveftp.com/backtrack)
- [www.nimblex.net](http://nimblex.net)
- [www.linux-live.org](http://linux-live.org)
- google tentunya :P

