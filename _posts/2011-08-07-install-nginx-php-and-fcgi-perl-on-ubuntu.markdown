--- 
layout: post_new
title: Install Nginx PHP and FCGI Perl on ubuntu
date: 2011-08-07 06:52:21
categories: 
- install
- Nginx
- PHP
- FCGI
- Perl
- ubuntu
---

##Quick How to

Install Dependencies

{% highlight bash %}
apt-get install nginx libfcgi-perl libfcgi-procmanager-perl
{% endhighlight %}


##FCGI perl on Nginx
###CGIWRAP-FCGI Perl Script

Grab this script save as `/usr/local/bin/cgiwrap-fcgi.pl` .

<script src="https://gist.github.com/1129889.js?file=cgiwrap-fcgi.pl" type="text/javascript">
</script>

###Nginx configuration for FCGI PERL

Add this script to `/etc/nginx/sites-available/default`. for php engine, replace `.pl` extention.
<script src="https://gist.github.com/1129889.js?file=nginx.conf" type="text/javascript">
</script>


###Run cgiwrap-fcgi.pl

{% highlight bash %}
root@imam-MS-7636:/usr/local/src/FCGI-0.71# /usr/local/bin/cgiwrap-fcgi.pl 
FastCGI: manager (pid 30814): initialized
FastCGI: manager (pid 30814): server (pid 30815) started
FastCGI: server (pid 30815): initialized
FastCGI: manager (pid 30814): server (pid 30816) started
FastCGI: manager (pid 30814): server (pid 30817) started
FastCGI: server (pid 30816): initialized
FastCGI: server (pid 30817): initialized
FastCGI: manager (pid 30814): server (pid 30818) started
FastCGI: manager (pid 30814): server (pid 30819) started
FastCGI: server (pid 30818): initialized
FastCGI: server (pid 30819): initialized
{% endhighlight %}


###PHP on Nginx

{% highlight bash %}
root@imam-MS-7636:/usr/local/src# apt-get install php5-cgi
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Suggested packages:
  php-pear
The following NEW packages will be installed:
  php5-cgi
0 upgraded, 1 newly installed, 0 to remove and 44 not upgraded.
Need to get 5,835kB of archives.
After this operation, 15.4MB of additional disk space will be used.
Get:1 http://id.archive.ubuntu.com/ubuntu/ maverick-updates/main php5-cgi i386 5.3.3-1ubuntu9.3 [5,835kB]
Fetched 5,835kB in 12s (484kB/s)                                                                                                                         
Selecting previously deselected package php5-cgi.
(Reading database ... 288925 files and directories currently installed.)
Unpacking php5-cgi (from .../php5-cgi_5.3.3-1ubuntu9.3_i386.deb) ...
Processing triggers for man-db ...
Setting up php5-cgi (5.3.3-1ubuntu9.3) ...

Creating config file /etc/php5/cgi/php.ini with new version
update-alternatives: using /usr/bin/php5-cgi to provide /usr/bin/php-cgi (php-cgi) in auto mode.
update-alternatives: using /usr/lib/cgi-bin/php5 to provide /usr/lib/cgi-bin/php (php-cgi-bin) in auto mode.
root@imam-MS-7636:/usr/local/src# php
php       php5      php5-cgi  php-cgi   
root@imam-MS-7636:/usr/local/src# 
{% endhighlight %}


##Troubleshooting error


{% highlight bash %}
root@imam-MS-7636:/usr/local/src/FCGI-0.71# /usr/local/bin/cgiwrap-fcgi.pl 
Can't locate FCGI/ProcManager.pm in @INC (@INC contains: /etc/perl /usr/local/lib/perl/5.10.1 /usr/local/share/perl/5.10.1 /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.10 /usr/share/perl/5.10 /usr/local/lib/site_perl .) at /usr/local/bin/cgiwrap-fcgi.pl line 5.
BEGIN failed--compilation aborted at /usr/local/bin/cgiwrap-fcgi.pl line 5.
root@imam-MS-7636:/usr/local/src/FCGI-0.71#



cpan[1]> install FCGI::ProcManager 
-------CUT-------
|
|
|

PERL_DL_NONLAZY=1 /usr/bin/perl "-MExtUtils::Command::MM" "-e" "test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/exporter.t ..... ok   
t/procmanager.t .. ok   
All tests successful.
Files=2, Tests=9,  0 wallclock secs ( 0.02 usr  0.01 sys +  0.03 cusr  0.00 csys =  0.06 CPU)
Result: PASS
  GBJK/FCGI-ProcManager-0.19.tar.gz
  make test -- OK
Warning (usually harmless): 'YAML' not installed, will not store persistent state
Running make install
Prepending /root/.cpan/build/FCGI-ProcManager-0.19-0aAT1g/blib/arch /root/.cpan/build/FCGI-ProcManager-0.19-0aAT1g/blib/lib to PERL5LIB for 'install'
Manifying blib/man3/FCGI::ProcManager.3pm
Appending installation info to /usr/local/lib/perl/5.10.1/perllocal.pod
Installing /usr/local/share/perl/5.10.1/FCGI/ProcManager.pm
Installing /usr/local/man/man3/FCGI::ProcManager.3pm
  GBJK/FCGI-ProcManager-0.19.tar.gz
  make install -j4 -- OK
Warning (usually harmless): 'YAML' not installed, will not store persistent state
{% endhighlight %}


{% highlight bash %}
cpan[1]> install YAML
CPAN: Storable loaded ok (v2.20)
Going to read '/root/.cpan/Metadata'
  Database was generated on Mon, 11 Apr 2011 19:34:01 GMT
Running install for module 'YAML'
CPAN: Data::Dumper loaded ok (v2.124)
'YAML' not installed, falling back to Data::Dumper and Storable to read prefs '/root/.cpan/prefs'
Running make for A/AD/ADAMK/YAML-0.72.tar.gz
CPAN: Digest::SHA loaded ok (v5.47)
CPAN: Compress::Zlib loaded ok (v2.02)
Checksum for /root/.cpan/sources/authors/id/A/AD/ADAMK/YAML-0.72.tar.gz ok
Scanning cache /root/.cpan/build for sizes
............................................................................DONE
CPAN: Archive::Tar loaded ok (v1.52)
YAML-0.72/
YAML-0.72/Makefile.PL
YAML-0.72/META.yml
YAML-0.72/LICENSE
YAML-0.72/README
YAML-0.72/xt/
YAML-0.72/xt/meta.t
YAML-0.72/xt/pmv.t
YAML-0.72/xt/pod.t
YAML-0.72/inc/
YAML-0.72/inc/Test/
YAML-0.72/inc/Test/Base/
YAML-0.72/inc/Test/Base/Filter.pm
YAML-0.72/inc/Test/More.pm
YAML-0.72/inc/Test/Builder/
YAML-0.72/inc/Test/Builder/Module.pm
YAML-0.72/inc/Test/Builder.pm
YAML-0.72/inc/Test/Base.pm
YAML-0.72/inc/Module/
YAML-0.72/inc/Module/Install.pm
YAML-0.72/inc/Module/Install/
YAML-0.72/inc/Module/Install/Can.pm
YAML-0.72/inc/Module/Install/Fetch.pm
YAML-0.72/inc/Module/Install/Win32.pm
YAML-0.72/inc/Module/Install/WriteAll.pm
YAML-0.72/inc/Module/Install/Metadata.pm
YAML-0.72/inc/Module/Install/Base.pm
YAML-0.72/inc/Module/Install/TestBase.pm
YAML-0.72/inc/Module/Install/Makefile.pm
YAML-0.72/inc/Module/Install/Include.pm
YAML-0.72/inc/Spiffy.pm
YAML-0.72/MANIFEST
YAML-0.72/Changes
YAML-0.72/t/
YAML-0.72/t/export.t
YAML-0.72/t/dump-code.t
YAML-0.72/t/load-spec.t
YAML-0.72/t/node-info.t
YAML-0.72/t/dump-perl-types.t
YAML-0.72/t/marshall.t
YAML-0.72/t/dump-tests.t
YAML-0.72/t/dump-blessed.t
YAML-0.72/t/TestYAML.pm
YAML-0.72/t/freeze-thaw.t
YAML-0.72/t/bugs-emailed.t
YAML-0.72/t/regexp.t
YAML-0.72/t/load-works.t
YAML-0.72/t/basic-tests.t
YAML-0.72/t/references.t
YAML-0.72/t/inbox.t
YAML-0.72/t/load-tests.t
YAML-0.72/t/dump-file-utf8.t
YAML-0.72/t/changes.t
YAML-0.72/t/dump-file.t
YAML-0.72/t/global-api.t
YAML-0.72/t/test.t
YAML-0.72/t/svk-config.yaml
YAML-0.72/t/bugs-rt.t
YAML-0.72/t/errors.t
YAML-0.72/t/dump-basics.t
YAML-0.72/t/2-scalars.t
YAML-0.72/t/Base.pm
YAML-0.72/t/long-quoted-value.yaml
YAML-0.72/t/dump-works.t
YAML-0.72/t/svk.t
YAML-0.72/t/dump-stringify.t
YAML-0.72/t/dump-nested.t
YAML-0.72/t/load-fails.t
YAML-0.72/t/load-passes.t
YAML-0.72/t/pugs-objects.t
YAML-0.72/t/dump-opts.t
YAML-0.72/t/load-slides.t
YAML-0.72/lib/
YAML-0.72/lib/YAML.pm
YAML-0.72/lib/YAML/
YAML-0.72/lib/YAML/Dumper.pm
YAML-0.72/lib/YAML/Any.pm
YAML-0.72/lib/YAML/Base.pm
YAML-0.72/lib/YAML/Dumper/
YAML-0.72/lib/YAML/Dumper/Base.pm
YAML-0.72/lib/YAML/Node.pm
YAML-0.72/lib/YAML/Tag.pm
YAML-0.72/lib/YAML/Loader/
YAML-0.72/lib/YAML/Loader/Base.pm
YAML-0.72/lib/YAML/Error.pm
YAML-0.72/lib/YAML/Marshall.pm
YAML-0.72/lib/YAML/Types.pm
YAML-0.72/lib/YAML/Loader.pm
YAML-0.72/lib/Test/
YAML-0.72/lib/Test/YAML.pm
CPAN: File::Temp loaded ok (v0.22)

  CPAN.pm: Going to build A/AD/ADAMK/YAML-0.72.tar.gz

Checking if your kit is complete...
Looks good
Writing Makefile for YAML
Could not read '/root/.cpan/build/YAML-0.72-g8iqO4/META.yml'. Falling back to other methods to determine prerequisites
cp lib/Test/YAML.pm blib/lib/Test/YAML.pm
cp lib/YAML/Types.pm blib/lib/YAML/Types.pm
cp lib/YAML/Node.pm blib/lib/YAML/Node.pm
cp lib/YAML/Loader.pm blib/lib/YAML/Loader.pm
cp lib/YAML/Any.pm blib/lib/YAML/Any.pm
cp lib/YAML/Error.pm blib/lib/YAML/Error.pm
cp lib/YAML/Loader/Base.pm blib/lib/YAML/Loader/Base.pm
cp lib/YAML.pm blib/lib/YAML.pm
cp lib/YAML/Dumper/Base.pm blib/lib/YAML/Dumper/Base.pm
cp lib/YAML/Marshall.pm blib/lib/YAML/Marshall.pm
cp lib/YAML/Base.pm blib/lib/YAML/Base.pm
cp lib/YAML/Tag.pm blib/lib/YAML/Tag.pm
cp lib/YAML/Dumper.pm blib/lib/YAML/Dumper.pm
Manifying blib/man3/Test::YAML.3pm
Manifying blib/man3/YAML::Types.3pm
Manifying blib/man3/YAML::Loader.3pm
Manifying blib/man3/YAML::Node.3pm
Manifying blib/man3/YAML::Any.3pm
Manifying blib/man3/YAML::Error.3pm
Manifying blib/man3/YAML::Loader::Base.3pm
Manifying blib/man3/YAML.3pm
Manifying blib/man3/YAML::Dumper::Base.3pm
Manifying blib/man3/YAML::Tag.3pm
Manifying blib/man3/YAML::Base.3pm
Manifying blib/man3/YAML::Marshall.3pm
Manifying blib/man3/YAML::Dumper.3pm
  ADAMK/YAML-0.72.tar.gz
  make -j4 -j4 -- OK
Warning (usually harmless): 'YAML' not installed, will not store persistent state
Running make test
PERL_DL_NONLAZY=1 /usr/bin/perl "-MExtUtils::Command::MM" "-e" "test_harness(0, 'inc', 'blib/lib', 'blib/arch')" t/*.t
t/2-scalars.t ........ ok   
t/basic-tests.t ...... ok   
t/bugs-emailed.t ..... ok     
t/bugs-rt.t .......... ok     
t/changes.t .......... ok   
t/dump-basics.t ...... ok   
t/dump-blessed.t ..... ok   
t/dump-code.t ........ ok   
t/dump-file-utf8.t ... ok   
t/dump-file.t ........ ok   
t/dump-nested.t ...... ok     
t/dump-opts.t ........ ok     
t/dump-perl-types.t .. ok     
t/dump-stringify.t ... ok   
t/dump-tests.t ....... ok     
t/dump-works.t ....... ok   
t/errors.t ........... ok     
t/export.t ........... ok   
t/freeze-thaw.t ...... ok   
t/global-api.t ....... ok   
t/inbox.t ............ ok   
t/load-fails.t ....... ok   
t/load-passes.t ...... ok   
t/load-slides.t ...... ok     
t/load-spec.t ........ ok     
t/load-tests.t ....... ok     
t/load-works.t ....... ok   
t/marshall.t ......... ok     
t/node-info.t ........ ok     
t/pugs-objects.t ..... ok   
t/references.t ....... ok     
t/regexp.t ........... ok     
t/svk.t .............. ok   
t/test.t ............. ok   
All tests successful.
Files=34, Tests=452,  4 wallclock secs ( 0.14 usr  0.04 sys +  3.00 cusr  0.23 csys =  3.41 CPU)
Result: PASS
  ADAMK/YAML-0.72.tar.gz
  make test -- OK
Warning (usually harmless): 'YAML' not installed, will not store persistent state
Running make install
Prepending /root/.cpan/build/YAML-0.72-g8iqO4/blib/arch /root/.cpan/build/YAML-0.72-g8iqO4/blib/lib to PERL5LIB for 'install'
Manifying blib/man3/Test::YAML.3pm
Manifying blib/man3/YAML::Types.3pm
Manifying blib/man3/YAML::Loader.3pm
Manifying blib/man3/YAML::Node.3pm
Manifying blib/man3/YAML::Any.3pm
Manifying blib/man3/YAML::Error.3pm
Manifying blib/man3/YAML::Loader::Base.3pm
Manifying blib/man3/YAML.3pm
Manifying blib/man3/YAML::Dumper::Base.3pm
Manifying blib/man3/YAML::Tag.3pm
Manifying blib/man3/YAML::Base.3pm
Manifying blib/man3/YAML::Marshall.3pm
Manifying blib/man3/YAML::Dumper.3pm
Appending installation info to /usr/local/lib/perl/5.10.1/perllocal.pod
Installing /usr/local/share/perl/5.10.1/YAML.pm
Installing /usr/local/share/perl/5.10.1/Test/YAML.pm
Installing /usr/local/share/perl/5.10.1/YAML/Any.pm
Installing /usr/local/share/perl/5.10.1/YAML/Node.pm
Installing /usr/local/share/perl/5.10.1/YAML/Marshall.pm
Installing /usr/local/share/perl/5.10.1/YAML/Error.pm
Installing /usr/local/share/perl/5.10.1/YAML/Types.pm
Installing /usr/local/share/perl/5.10.1/YAML/Loader.pm
Installing /usr/local/share/perl/5.10.1/YAML/Dumper.pm
Installing /usr/local/share/perl/5.10.1/YAML/Base.pm
Installing /usr/local/share/perl/5.10.1/YAML/Tag.pm
Installing /usr/local/share/perl/5.10.1/YAML/Dumper/Base.pm
Installing /usr/local/share/perl/5.10.1/YAML/Loader/Base.pm
Installing /usr/local/man/man3/YAML::Loader::Base.3pm
Installing /usr/local/man/man3/YAML::Dumper::Base.3pm
Installing /usr/local/man/man3/YAML.3pm
Installing /usr/local/man/man3/YAML::Any.3pm
Installing /usr/local/man/man3/YAML::Error.3pm
Installing /usr/local/man/man3/YAML::Base.3pm
Installing /usr/local/man/man3/YAML::Tag.3pm
Installing /usr/local/man/man3/YAML::Marshall.3pm
Installing /usr/local/man/man3/YAML::Node.3pm
Installing /usr/local/man/man3/YAML::Types.3pm
Installing /usr/local/man/man3/Test::YAML.3pm
Installing /usr/local/man/man3/YAML::Loader.3pm
Installing /usr/local/man/man3/YAML::Dumper.3pm
  ADAMK/YAML-0.72.tar.gz
  make install -j4 -- OK
CPAN: YAML loaded ok (v0.72)
{% endhighlight %}


##Install FCGI PERL module 

{% highlight bash %}
cpan[2]> install FCGI::ProcManager 
FCGI::ProcManager is up to date (0.19).
{% endhighlight %}


`Can't locate syscall.ph`.



{% highlight bash %}
root@darkstar:/usr/include# /usr/local/bin/cgiwarp-fcgi.pl 
Illegal declaration of subroutine main::__INT16_C at /usr/lib/perl5/site_perl/5.12.3/i486-linux-thread-multi/_h2ph_pre.ph line 158.
Compilation failed in require at /usr/lib/perl5/site_perl/5.12.3/i486-linux-thread-multi/syscall.ph line 1.
Compilation failed in require at /usr/local/bin/cgiwarp-fcgi.pl line 9.
root@darkstar:/usr/include# perl -e 'require("syscall.ph")';
Illegal declaration of subroutine main::__INT16_C at /usr/lib/perl5/site_perl/5.12.3/i486-linux-thread-multi/_h2ph_pre.ph line 158.
Compilation failed in require at /usr/lib/perl5/site_perl/5.12.3/i486-linux-thread-multi/syscall.ph line 1.
Compilation failed in require at -e line 1.
root@darkstar:/usr/include# 
{% endhighlight %}


Reference:

1. [http://wiki.nginx.org/NginxSimpleCGI](http://wiki.nginx.org/NginxSimpleCGI)
2. [http://www.nakedmcse.com/Home/tabid/39/forumid/14/threadid/37/scope/posts/Default.aspx](http://www.nakedmcse.com/Home/tabid/39/forumid/14/threadid/37/scope/posts/Default.aspx)
3. [http://www.livejournal.com/doc/server/lj.install.perl_setup.modules.htmlhttp://www.livejournal.com/doc/server/lj.install.perl_setup.modules.html](http://www.livejournal.com/doc/server/lj.install.perl_setup.modules.htmlhttp://www.livejournal.com/doc/server/lj.install.perl_setup.modules.html)
4. [http://wiki.nginx.org/FcgiExample](http://wiki.nginx.org/FcgiExample)
5. [http://tomasz.sterna.tv/2009/04/php-fastcgi-with-nginx-on-ubuntu/](http://tomasz.sterna.tv/2009/04/php-fastcgi-with-nginx-on-ubuntu/)
6. [http://docstore.mik.ua/orelly/perl/cookbook/ch12_15.htm](http://docstore.mik.ua/orelly/perl/cookbook/ch12_15.htm)


