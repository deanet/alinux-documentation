--- 
layout: post_new
title: Make Nagios notification to SMS via Twitter update
date: 2011-07-30 22:30:37
categories: 
- Nagios
- Notify
- Twitter
- SMS
---

##Install Dependencies

{% highlight bash %}

yum install python-setuptools-0.6c5-2.el5.noarch
yum install -y python26-simplejson.x86_64
yum install -y python-simplejson.x86_64
yum install -y python-cjson.x86_64

{% endhighlight %}


##Install Tweepy, Python Twitter Client

Installing Tweepy.


<script src='https://gist.github.com/1026765.js?file=tweepy.sh' type="text/javascript">
</script>



##Grab Code and Make Auth.

Grab coderiver.py on github and run it.

<script src='https://gist.github.com/1026765.js?file=coderiver.py' type="text/javascript">
</script>

Run it.

{% highlight bash %}
[root@master sms]# python coderiver.py 
Please authorize: http://twitter.com/oauth/authorize?oauth_token=wAAZYcMh454UGdjB5Qo3NNwmF0XMxnG0TgYKb57bGFk
PIN: 6355846
ACCESS_KEY = '97888754-tEz8cPpNT920kjAJ4UzHqMKpHhB22F6V2JvP4rAaX'
ACCESS_SECRET = 'SRaHdcr4MA2A2Fx4e4ftF8WmCQZywbwaOio3ghPw'
{% endhighlight %}


{% highlight bash %}
[root@master sms]# vim sms.py 
{% endhighlight %}


<script src='https://gist.github.com/1026765.js?file=sms.py' type="text/javascript">
</script>

##Testing 
{% highlight bash %}

[root@master sms]# ./sms.py 'admin e sopo iki ?? server e down'
{% endhighlight %}



tambahkan command di nagios / groundwork nagios (saya pake yg ini)


<script src='https://gist.github.com/1026765.js?file=nagios.cfg' type="text/javascript">
</script>

ref:

[http://talkfast.org/2010/05/31/twitter-from-the-command-line-in-python-using-oauth](http://talkfast.org/2010/05/31/twitter-from-the-command-line-in-python-using-oauth)
