---
layout: default
title: Archive
---

#Archive 

<ul class="posts">
	{% for post in site.posts  %}
	<li><span>{{ post.date | date: "%b %d %Y" }}</span> &raquo; <a href="{{ post.url }}">{{ post.title | xml_escape }}</a></li>
	{% endfor %}
</ul>

