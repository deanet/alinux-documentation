based theme on neban.github.com

##changes
- search archives
- make simply files on category archives with rakefile

###command list


- `rake draft["untitled"]`
creating draft untitled, make sure your env $EDITOR have been set to your favourite editor.

- `rake post[untitled]`
posting untitled file.

- `rake update["untitled"]`
updating untitled file.

- `rake clean`
cleaning up dir `tags/` `_site/`

- `rake taggen`
generating tag cloud

- `rake server`
run webrick server

- `rake publish`
run clean, taggen, and jekyll
`please read the c0de first`

- `rake sync`
sync dir `_site/` to publish dir server

