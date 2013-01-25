--- 
layout: post_new
title: Redirect Spree URL on Heroku to Custom Domain
date: 2012-10-13 11:14:22
categories: [c0ding, ruby, heroku]
---



append to `config/application.rb`

<script src="https://gist.github.com/3882067.js?file=append_to.rb" type="text/javascript">
</script>

create file `lib/no_www.rb`

<script src="https://gist.github.com/3882067.js?file=redirect.rb" type="text/javascript">
</script>


it will redirect [http://pasarcairo.herokuapp.com](http://pasarcairo.herokuapp.com) to [http://pasarcairo.com](http://pasarcairo.com)


ref:
1. [http://blog.misza.co.uk/2010/01/redirecting-in-rack.html](http://blog.misza.co.uk/2010/01/redirecting-in-rack.html)
2. [http://stackoverflow.com/questions/4046960/how-to-redirect-without-www-using-rails-3-rack](http://stackoverflow.com/questions/4046960/how-to-redirect-without-www-using-rails-3-rack)
