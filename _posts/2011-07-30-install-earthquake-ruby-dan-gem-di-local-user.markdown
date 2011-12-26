--- 
layout: post_new
title: Install Earthquake Ruby dan Gem di local user
date: 2011-07-30 21:47:30
categories: 
- Twitter
- Client
- Ruby
- Gem
---




##Install Ruby di lingkungan user (tanpa akses root)

{% highlight bash %}
dhanuxe@plox:~$ mkdir ~/local2
dhanuxe@plox:~$ cd ~/local2/
dhanuxe@plox:~/local2$ wget -c http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.bz2
dhanuxe@plox:~/local2$ tar -xf ruby-1.9.2-p180.tar.bz2 
dhanuxe@plox:~/local2$ cd ruby-1.9.2-p180
dhanuxe@plox:~/local2/ruby-1.9.2-p180$ ./configure --prefix=/home/dhanuxe/local2/ruby
dhanuxe@plox:~/local2/ruby-1.9.2-p180$ make

snipped

No definition for rb_io_print
No definition for rb_io_printf
No definition for rb_io_puts
100% [515/515]  doc/re.rdoc                                                     

Generating RI...

Files:       515
Classes:    1087 (  654 undocumented)
Constants:  1364 ( 1141 undocumented)
Modules:     239 (  137 undocumented)
Methods:    7642 ( 2876 undocumented)
 53.46% documented


Elapsed: 199.0s

dhanuxe@plox:~/local2/ruby-1.9.2-p180$ make install
./miniruby -I./lib -I.ext/common -I./- -r./ext/purelib.rb  ./tool/generic_erb.rb -c -o encdb.h ./template/encdb.h.tmpl ./enc enc
encdb.h unchanged

snipped

installing command scripts:   /home/dhanuxe/local2/ruby/bin
installing library scripts:   /home/dhanuxe/local2/ruby/lib/ruby/1.9.1
installing common headers:    /home/dhanuxe/local2/ruby/include/ruby-1.9.1
installing manpages:          /home/dhanuxe/local2/ruby/share/man/man1
installing default gems:      /home/dhanuxe/local2/ruby/lib/ruby/gems/1.9.1 (cache, doc, gems, specifications)
                              rake 0.8.7
                              rdoc 2.5.8
                              minitest 1.6.0
{% endhighlight %}


##setting PATH ENV

{% highlight bash %}
dhanuxe@plox:~/local2/ruby-1.9.2-p180$ vim ~/.bashrc 

export PATH=/home/dhanuxe/local2/ruby/bin:$PATH

dhanuxe@plox:~$ exit
logout
Connection to ssh.alinux.web.id closed.
bash-4.1$ ssh dhanuxe@ssh.alinux.web.id
dhanuxe@ssh.alinux.web.id's password: 

Welcome to shelltor.com

No mail.
Last login: Sat Jun 11 10:09:02 2011 from 114.79.1.57
whooopppppppssssssssssssssssss...
enter pass pleaseeee.. :D : 
great !!
        found the bug ?? submit to hax@plox.tor.hu
dhanuxe@plox:~$ ruby -v
ruby 1.9.2p180 (2011-02-18 revision 30909) [x86_64-linux]

{% endhighlight %}


## Install Gem Ruby


{% highlight bash %}
dhanuxe@plox:~$ cd ~/local2
dhanuxe@plox:~/local2$ wget -c http://rubyforge.org/frs/download.php/74954/rubygems-1.8.5.tgz
dhanuxe@plox:~/local2$ tar -xf rubygems-1.8.5.tgz
dhanuxe@plox:~/local2$ cd rubygems-1.8.5
dhanuxe@plox:~/local2/rubygems-1.8.5$ ruby setup.rb --prefix=/home/dhanuxe/local2/gemrepo
RubyGems 1.8.5 installed

﻿=== 1.8.4 / 2011-05-31

* 1 minor enhancement:

  * The -u option to 'update local source cache' is official deprecated.
  * Remove has_rdoc deprecations from Specification.

* 2 bug fixes:

  * Handle bad specs more gracefully.
  * Reset any Gem paths changed in the installer.


------------------------------------------------------------------------------

RubyGems installed the following executables:
        /home/dhanuxe/local2/gemrepo/bin/gem

dhanuxe@plox:~/local2/rubygems-1.8.5$ gem -v
1.3.7
dhanuxe@plox:~$ vim ~/.bashrc 


export PATH=/home/dhanuxe/local2/gemrepo/bin:/home/dhanuxe/local2/ruby/bin:$PATH


dhanuxe@plox:~/local2/rubygems-1.8.5$ exit
logout
Connection to ssh.alinux.web.id closed.
bash-4.1$ ssh dhanuxe@ssh.alinux.web.id
dhanuxe@ssh.alinux.web.id's password: 

Welcome to shelltor.com

No mail.
Last login: Sat Jun 11 10:06:40 2011 from 114.79.1.57
whooopppppppssssssssssssssssss...
enter pass pleaseeee.. :D : 
great !!
        found the bug ?? submit to hax@plox.tor.hu
dhanuxe@plox:~$ gem -v
1.3.7
dhanuxe@plox:~$ gem update --system
Updating RubyGems
Updating rubygems-update
Successfully installed rubygems-update-1.8.5
Updating RubyGems to 1.8.5
Installing RubyGems 1.8.5
RubyGems 1.8.5 installed

﻿=== 1.8.5 / 2011-05-31

* 2 minor enhancement:

  * The -u option to 'update local source cache' is official deprecated.
  * Remove has_rdoc deprecations from Specification.

* 2 bug fixes:

  * Handle bad specs more gracefully.
  * Reset any Gem paths changed in the installer.


------------------------------------------------------------------------------

RubyGems installed the following executables:
        /home/dhanuxe/local2/ruby/bin/gem

dhanuxe@plox:~$ gem -v
1.8.5
dhanuxe@plox:~$ ./local2/gemrepo/bin/gem -v
1.8.5
dhanuxe@plox:~$ /home/dhanuxe/local2/ruby/bin/gem -v
1.8.5
dhanuxe@plox:~$ 
{% endhighlight %}


##Install Earthquake

Earthquake = Twitter Client based terminal konsole.

{% highlight bash %}
dhanuxe@plox:~/local2$ git clone git://github.com/deanet/earthquake.git
Cloning into earthquake...
remote: Counting objects: 1744, done.
remote: Compressing objects: 100% (749/749), done.
remote: Total 1744 (delta 1000), reused 1666 (delta 936)
Receiving objects: 100% (1744/1744), 174.00 KiB | 42 KiB/s, done.
Resolving deltas: 100% (1000/1000), done.
dhanuxe@plox:~/local2$ cd earthquake/
dhanuxe@plox:~/local2/earthquake$ cat dep.txt | xargs gem install
Fetching: eventmachine-0.12.10.gem (100%)
Building native extensions.  This could take a while...
Successfully installed eventmachine-0.12.10
Fetching: simple_oauth-0.1.5.gem (100%)
Successfully installed simple_oauth-0.1.5
Fetching: notify-0.3.0.gem (100%)
Successfully installed notify-0.3.0
Fetching: i18n-0.6.0.gem (100%)
Successfully installed i18n-0.6.0
Fetching: activesupport-3.0.8.gem (100%)
Successfully installed activesupport-3.0.8
Fetching: awesome_print-0.4.0.gem (100%)
Successfully installed awesome_print-0.4.0
Fetching: configuration-1.2.0.gem (100%)
Successfully installed configuration-1.2.0
Fetching: launchy-0.4.0.gem (100%)
Successfully installed launchy-0.4.0
Fetching: oauth-0.4.4.gem (100%)
Successfully installed oauth-0.4.4
Fetching: json-1.5.1.gem (100%)
Building native extensions.  This could take a while...
Successfully installed json-1.5.1
Fetching: mime-0.1.gem (100%)
Successfully installed mime-0.1
Fetching: twitter-stream-0.1.13.gem (100%)
Successfully installed twitter-stream-0.1.13
Fetching: mime-types-1.16.gem (100%)
Fetching: twitter_oauth-0.4.3.gem (100%)
Successfully installed mime-types-1.16
Successfully installed twitter_oauth-0.4.3
Fetching: slop-1.7.0.gem (100%)
Successfully installed slop-1.7.0
15 gems installed
Installing ri documentation for eventmachine-0.12.10...
Installing ri documentation for simple_oauth-0.1.5...
Installing ri documentation for notify-0.3.0...
Installing ri documentation for i18n-0.6.0...
Installing ri documentation for activesupport-3.0.8...
Installing ri documentation for awesome_print-0.4.0...
Installing ri documentation for configuration-1.2.0...
Installing ri documentation for launchy-0.4.0...
Installing ri documentation for oauth-0.4.4...
Installing ri documentation for json-1.5.1...
Installing ri documentation for mime-0.1...
Installing ri documentation for twitter-stream-0.1.13...
Installing ri documentation for mime-types-1.16...
Installing ri documentation for twitter_oauth-0.4.3...
Installing ri documentation for slop-1.7.0...
Installing RDoc documentation for eventmachine-0.12.10...
Installing RDoc documentation for simple_oauth-0.1.5...
Installing RDoc documentation for notify-0.3.0...
Installing RDoc documentation for i18n-0.6.0...
Installing RDoc documentation for activesupport-3.0.8...
Installing RDoc documentation for awesome_print-0.4.0...
Installing RDoc documentation for configuration-1.2.0...
Installing RDoc documentation for launchy-0.4.0...
Installing RDoc documentation for oauth-0.4.4...
Installing RDoc documentation for json-1.5.1...
Installing RDoc documentation for mime-0.1...
Installing RDoc documentation for twitter-stream-0.1.13...
Installing RDoc documentation for mime-types-1.16...
Installing RDoc documentation for twitter_oauth-0.4.3...
Installing RDoc documentation for slop-1.7.0...
{% endhighlight %}

<img src="https://github.com/deanet/earthquake/raw/master/earthquake.png" border="0">
