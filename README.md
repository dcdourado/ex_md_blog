[![Actions Status](https://github.com/dcdourado/ex_md_blog/workflows/Elixir%20CI/badge.svg)](https://github.com/dcdourado/ex_md_blog/actions/workflows/elixir-ci.yml)

# ExMdBlog

https://dcdourado.me/

The blog goal is to learn, write and practice about software engineering principles.
I want to write more stuff and maybe this is going to be an incentive to do it more.

## The project

Using `:cowboy` we will expose a web server that renders posts (our main resource) written in markdown.

Roadmap to v1.0.0

- [x] Set up web server
- [x] Create Posts domain
- [x] Build a Markdown-to-HTML parser
- [x] Render blog HTML dynamically
- [x] First real blog post about what we've done so far
- [x] Deploy app


## Setup

```shell
mix deps.get
mix deps.compile
mix compile

# run
iex -S mix
```

Blog can be accessed locally at http://localhost:8080/

## Deploy

```shell
flyctl deploy
```
