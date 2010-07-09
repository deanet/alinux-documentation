---
layout: default
title: home
---

# $ ls -lt | awk '{ print $6" "$8 }'

<ul class="posts">
	{% for post in site.posts offset:0 limit:10  %}
	<li><span>{{ post.date | date: "%b %d %Y" }}</span> &raquo; <a href="{{ post.url }}">{{ post.title | xml_escape }}</a></li>
	{% endfor %}
</ul>

## [Archive](/archive.html)
