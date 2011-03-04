---
layout: default_new
title: Archive
---

#Archive 
<br/>

<ul class="posts" id="archive">
	{% for post in site.posts  %}
	<li><a href="{{ site.pet }}{{ post.url }}">{{ post.title | xml_escape }}</a> - <span>{{ post.date | date: "%b %d %Y" }}</span></li>
	{% endfor %}
</ul>

